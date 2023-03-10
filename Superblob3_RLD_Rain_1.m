function [leachy,uppy,gas] = Superblob3_RLD_Rain_1(t1, t2,rain_name)
tic
%% Runs FEM solver for water transport and N transport/transformation equations: 
%rain_name is a string giving location of Rain.txt file. eg. Rain_31.txt

% -------- Richards equation------
% i) phi*dSdP*dPdt = d(ks*k(S(P))/mu*(dPdz+rho*g))dz - Fw
%
% -------- Nitrogen------
% ii) 
% iii) 
% iv) 
%

            if nargin<2
                t2 = 86400*14*4; % Fertilizer application time 2
                if nargin<1
                    t1 = 86400*14; % Fertilizer application time 1
                    
                end
            end
%         
t1s = num2str(t1);
t2s = num2str(t2);

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');
model.modelPath(pwd); 

model.label('SuperblobRLD_Master.mph');

%Soil params
model.param.set('psi', '0.4', 'Porosity');
model.param.set('m', '0.5', 'Van G');
model.param.set('ks', '5e-14', 'Saturated Permeability m^2');
model.param.set('mu', '8.9e-4', 'Viscoscity kg/m*s');
model.param.set('d', '2', 'Tortuosity');
model.param.set('b', '1', 'Buffer Power');
model.param.set('phis', '0.6', 'solid mineral volume fraction');
model.param.set('Vmax', '3.33e-9', 'Max reaction rate');
model.param.set('UNH4', '1.2989e-5', 'Sorption rate NH4');
model.param.set('UDON', '3.7111e-6', 'Sorption rate DON');
model.param.set('kapI2', '1.7708e-6', 'Immobilization rate NO3');
model.param.set('kapM', '2.2222e-4', 'Mineralizaiton rate');
model.param.set('kapN', '3.5417e-4', 'Nitrification rate');
model.param.set('kapI1', '6.4815e-5', 'Imobilization rate NH4');
model.param.set('kapNH4', '4.6e-3', 'Release rate NH4');
model.param.set('kapNO3', '4.6e-3', 'Release rate NO3');
model.param.set('kapDON', '4.6e-3', 'Release rate DON');
model.param.set('KI2', '9.5e-4', 'MM NO3 immobilization coef');
model.param.set('KM', '1.5e-5', 'MM mineralization coef');
model.param.set('KN', '9.4e-6', 'MM nitrification');
model.param.set('KI1', '5.1e-5', 'MM NH4 immobilization coef');
model.param.set('as', '44.4', 'Specific surface area of sand');
model.param.set('rhos', '2700', 'Solid mineral density');
model.param.set('g', '9.81', 'Gravity m/s^2');
model.param.set('row', '1000', 'Density kg/m^3');


%Root params
model.param.set('kr', '2.4987e-13', 'kr radial water conductivity_from Tiinas paper');
model.param.set('Pr', '-2.75e5', 'Root Pressure Pa');
model.param.set('r0', '2e-7/2', 'Initial Growth Rate');
model.param.set('Pc', '23200', 'Suction kg/m*s^2');
model.param.set('K0', '0.5', 'Max Root Length m');
model.param.set('gamma', '0.5772156649', 'Euler-Maschoroni');
model.param.set('a0', '5e-4*0+.3e-3', 'Root Radii m');
model.param.set('Fm', '10e-5', 'Max Uptake');
model.param.set('Km', '0.025', 'Michaleis Uptake');
model.param.set('introot', '0.05', 'Initial Root Length m');
model.param.set('a1', '5e-4/6*0+0.032e-3', 'radius of first order lateral roots [m]');
model.param.set('K1', '.08', 'Length of lateral[m]');
model.param.set('beta', 'pi/4', 'branching angle [rad]');
model.param.set('kz', '1.198e-14', 'Axial first order xylem hydraulic conductivity [m4 s-1 Pa-1]');
model.param.set('Kd', '60e3/4', 'Maximum root length density [m m-3]');
model.param.set('rd', '1.2e-2', 'initial root length density rate [m m-3 s-1]');
model.param.set('ratio', 'Qs/(ks*row*g/mu)');


model.param.set('Qs', '3.14e-7', 'Rainfall m/s');
model.param.set('Qa', '1e-5', 'Nitrogen application kg m^-2 s^-1');
model.param.set('Df', '2e-9', 'Liquid Diffusion m^2/s');


model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 1);

model.result.table.create('tbl1', 'Table');
model.result.table.create('tbl2', 'Table');
model.result.table.create('tbl3', 'Table');
model.result.table.create('tbl4', 'Table');
model.result.table.create('tbl5', 'Table');
model.result.table.create('tbl6', 'Table');

model.func.create('an1', 'Analytic');
model.func.create('an2', 'Analytic');
model.func.create('an3', 'Analytic');
model.func.create('an4', 'Analytic');
model.func.create('an6', 'Analytic');
model.func.create('an7', 'Analytic');
model.func.create('rect1', 'Rectangle');
model.func.create('an8', 'Analytic');
model.func.create('an9', 'Analytic');
model.func.create('an10', 'Analytic');
model.func.create('an11', 'Analytic');
model.func.create('step1', 'Step');
model.func.create('gp1', 'GaussianPulse');
model.func.create('gp2', 'GaussianPulse');
model.func.create('step2', 'Step');
model.func.create('an12', 'Analytic');
model.func.create('an13', 'Analytic');
model.func.create('step3', 'Step');
model.func.create('rn1', 'Random');
model.func.create('step4', 'Step');
model.func.create('int1', 'Interpolation');
model.func.create('rn2', 'Random');
model.func.create('an14', 'Analytic');
model.func.create('an15', 'Analytic');
model.func.create('an16', 'Analytic');
model.func.create('an17', 'Analytic');
model.func.create('int2', 'Interpolation');
model.func.create('rn3', 'Random');
model.func('an1').set('funcname', 'S');
model.func('an1').set('expr', '(((-p/Pc)^(1/(1-m)))+1)^(-m)');
model.func('an1').set('args', {'p'});
model.func('an1').set('plotargs', {'p' '-1e6' '0'});
model.func('an2').set('funcname', 'Gam');
model.func('an2').set('expr', '(ks/mu)*(S(p)^0.5)*((1-((1-(S(p)^(1/m)))^(m)))^(2))');
model.func('an2').set('args', {'p'});
model.func('an2').set('plotargs', {'p' '0' '1'});
model.func('an3').set('funcname', 'Diff');
model.func('an3').set('expr', 'Df*(psi^(d+1))*(S(p)^(d+1))');
model.func('an3').set('args', {'p'});
model.func('an3').set('plotargs', {'p' '0' '1'});
model.func('an4').set('funcname', 'Fw');
model.func('an4').set('expr', '-(lambda*(p-Pr))');
model.func('an4').set('args', {'p'});
model.func('an4').set('plotargs', {'p' '0' '1'});
model.func('an6').set('funcname', 'Da');
model.func('an6').set('expr', 'psi*(d(S(p),p))');
model.func('an6').set('args', {'p'});
model.func('an6').set('plotargs', {'p' '-10000' '10000'});
model.func('an7').set('funcname', 'ST');
model.func('an7').set('expr', '(psi*S(p))');
model.func('an7').set('args', {'p'});
model.func('an7').set('plotargs', {'p' '0' '1'});
model.func('rect1').set('lower', 0);
model.func('rect1').set('upper', '86400*4');
model.func('rect1').set('smooth', 86400);
model.func('an8').set('funcname', 'alpha0');
model.func('an8').set('expr', '4*exp(-gamma) * Df * psi^(d+1) * S(p)^(d+1) / (a0^2 * b * (1 +S(p)*psi/b ))');
model.func('an8').set('args', {'p'});
model.func('an8').set('plotargs', {'p' '-100000' '-100'});
model.func('an9').set('funcname', 'lambda0');
model.func('an9').set('expr', 'Fm*a0/(Km * Df * psi^(d+1) * S(p)^(d+1) )');
model.func('an9').set('args', {'p'});
model.func('an9').set('plotargs', {'p' '-100000' '-100'});
model.func('an10').set('funcname', 'L0');
model.func('an10').set('expr', '(lambda0(p)/2)*log(alpha0(p)*t+alpha0(p)*(K0/r0)*log(1 + z/K0)+1)');
model.func('an10').set('args', {'p' 'z' 't'});
model.func('an10').set('plotargs', {'p' '-100000' '-100'; 'z' '0.2' '0.2'; 't' '86400' '86400'});
model.func('an11').set('funcname', 'F0');
model.func('an11').set('expr', '2*pi*a0 * 2 * (Fm/Km) * c / (1 + (c/Km) + L0(p,z,t) + sqrt( (4*c/Km) + (1-(c/Km) + L0(p,z,t))^2 ) )');
model.func('an11').set('args', {'p' 'z' 't' 'c'});
model.func('an11').set('plotargs', {'p' '-1000000' '-100';  ...
'z' '0.2' '0.2';  ...
't' '86400*10' '86400*10';  ...
'c' '1' '1'});
model.func('step1').set('smooth', 86400);
model.func('gp1').set('location', t1);
model.func('gp1').set('sigma', 30000);
model.func('gp2').set('location', t2);
model.func('gp2').set('sigma', 30000);
model.func('step2').set('from', 1);
model.func('step2').set('to', 0);
model.func('step2').set('smooth', '86400*7');
model.func('an12').label('primary_length');
model.func('an12').set('funcname', 'l0new');
model.func('an12').set('expr', 'K0*(1-exp(-r0/K0*t))');
model.func('an12').set('args', {'t'});
model.func('an12').set('plotargs', {'t' '0' '60*60*24*140'});
model.func('an13').label('Root length density');
model.func('an13').set('funcname', 'ldnew');
model.func('an13').set('expr', 'Kd*(1-(1-x/K0)^(-(rd/Kd*K0/r0))*exp(-rd/Kd*t))*(x<l0(t))+1');
model.func('an13').set('args', {'x' 't'});
model.func('an13').set('plotargs', {'x' '0' 'K0'; 't' '0' '112*60*60*24'});
model.func('step3').active(false);
model.func('rn1').set('funcname', 'rn');
model.func('rn1').set('type', 'normal');
model.func('rn1').set('mean', 'Qs');
model.func('rn1').set('normalsigma', '.05*Qs');
model.func('step4').label('StepBC');
model.func('step4').set('funcname', 'stepBC');
model.func('step4').set('location', -2000);
model.func('step4').set('smooth', 100);
model.func('int1').set('source', 'file');
model.func('int1').set('filename', rain_name); %CHANGE TO RIGHT RAIN
model.func('int1').set('importedstruct', 'Spreadsheet');
model.func('int1').set('importeddim', '1D');
model.func('int1').set('interp', 'piecewisecubic');

model.file('res1').resource(rain_name); %CHANGE TO RIGHT RAIN

model.func('int1').set('source', 'file');
model.func('int1').set('nargs', '1');
model.func('int1').set('struct', 'spreadsheet');
model.func('rn2').set('type', 'normal');
model.func('rn2').set('mean', 'Qs');
model.func('rn2').set('normalsigma', '.05*Qs');
model.func('an14').set('funcname', 'F1');
model.func('an14').set('expr', '2*pi*a1 * 2 * (Fm/Km) * c / (1 + (c/Km) + L1(p,z,t) + sqrt( (4*c/Km) + (1-(c/Km) + L1(p,z,t))^2 ) )');
model.func('an14').set('args', {'p' 'z' 't' 'c'});
model.func('an14').set('plotargs', {'p' '-1000000' '-100';  ...
'z' '0.2' '0.2';  ...
't' '86400*10' '86400*10';  ...
'c' '1' '1'});
model.func('an15').set('funcname', 'alpha1');
model.func('an15').set('expr', '4*exp(-gamma) * Df * psi^(d+1) * S(p)^(d+1) / (a1^2 * b * (1 +S(p)*psi/b ))');
model.func('an15').set('args', {'p'});
model.func('an15').set('plotargs', {'p' '-100000' '-100'});
model.func('an16').set('funcname', 'lambda1');
model.func('an16').set('expr', 'Fm*a1/(Km * Df * psi^(d+1) * S(p)^(d+1) )');
model.func('an16').set('args', {'p'});
model.func('an16').set('plotargs', {'p' '-100000' '-100'});
model.func('an17').set('funcname', 'L1');
model.func('an17').set('expr', '(lambda1(p)/2)*log(alpha1(p)*t+alpha1(p)*(K0/r0)*log(1 + z/K0)+1)');
model.func('an17').set('args', {'p' 'z' 't'});
model.func('an17').set('plotargs', {'p' '-100000' '-100'; 'z' '0.2' '0.2'; 't' '86400' '86400'});
model.func('int2').label('Tiago_Rain_CDF');
model.func('int2').set('source', 'file');
model.func('int2').set('filename', rain_name);
model.func('rn3').label('uniform_dist');
model.func('rn3').set('funcname', 'uni_rn');
model.func('rn3').set('mean', '.5');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('i1', 'Interval');
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').feature('pt1').set('p', {'introot'});
model.component('comp1').geom('geom1').run;

model.component('comp1').cpl.create('intop1', 'Integration');
model.component('comp1').cpl('intop1').selection.set([1 2]);

model.component('comp1').physics.create('dode', 'DomainODE', 'geom1');
model.component('comp1').physics('dode').field('dimensionless').field('ldnewnew');
model.component('comp1').physics('dode').field('dimensionless').component({'ldnewnew'});
model.component('comp1').physics('dode').selection.set([1]);
model.component('comp1').physics.create('g', 'GeneralFormPDE', 'geom1');
model.component('comp1').physics('g').field('dimensionless').component({'p' 'NO3' 'NO3s' 'NORG' 'NORGs' 'NH4' 'NH4s' 'ld'});
model.component('comp1').physics('g').create('flux1', 'FluxBoundary', 0);
model.component('comp1').physics('g').feature('flux1').selection.set([1]);
model.component('comp1').physics('g').create('dir1', 'DirichletBoundary', 0);
model.component('comp1').physics('g').feature('dir1').selection.set([3]);
model.component('comp1').physics('g').create('ge1', 'GlobalEquations', -1);
model.component('comp1').physics('g').create('flux2', 'FluxBoundary', 0);
model.component('comp1').physics('g').feature('flux2').selection.set([3]);
model.component('comp1').physics('g').create('src1', 'SourceTerm', 1);
model.component('comp1').physics('g').feature('src1').selection.set([1]);
model.component('comp1').physics.create('dg', 'DeformedGeometry', 'geom1');
model.component('comp1').physics('dg').create('free1', 'FreeDeformation', 1);
model.component('comp1').physics('dg').feature('free1').selection.set([1 2]);
model.component('comp1').physics('dg').create('disp3', 'PrescribedMeshDisplacement', 0);
model.component('comp1').physics('dg').feature('disp3').selection.set([1 3]);
model.component('comp1').physics('dg').create('disp2', 'PrescribedMeshDisplacement', 0);
model.component('comp1').physics('dg').feature('disp2').selection.set([2]);
model.component('comp1').physics.create('poeq', 'PoissonEquation', 'geom1');
model.component('comp1').physics('poeq').field('dimensionless').field('pr');
model.component('comp1').physics('poeq').selection.set([1]);
model.component('comp1').physics('poeq').create('dir1', 'DirichletBoundary', 0);
model.component('comp1').physics('poeq').feature('dir1').selection.set([1]);
model.component('comp1').physics('poeq').create('flux1', 'FluxBoundary', 0);
model.component('comp1').physics('poeq').feature('flux1').selection.set([2]);

model.component('comp1').mesh('mesh1').create('edg1', 'Edge');

model.result.table('tbl1').comments('Line Integration 1 -(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-86400*28*4)*(x<l0)');
model.result.table('tbl2').comments('Line Integration 2 ((ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-86400*28*4)*(x<l0))');
model.result.table('tbl3').comments('Point Evaluation 1 ()');
model.result.table('tbl4').comments('Point Evaluation 2 ((-NO3*(Gam(p))*(px+(row*g))) + (-(Diff(p))*NO3x))');
model.result.table('tbl5').comments('Line Integration 2 (-(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-86400*28*4)*(x<l0))');
model.result.table('tbl6').comments('Line Integration 3 ((ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-86400*28*4)*(x<l0))');

model.component('comp1').view('view1').axis.set('xmin', -0.04999998211860657);
model.component('comp1').view('view1').axis.set('xmax', 1.0499999523162842);

model.component('comp1').physics('dode').active(false);
model.component('comp1').physics('dode').feature('dode1').set('f', 'rd*(1-ld/Kd)*(x<l0)');
model.component('comp1').physics('dode').feature('init1').set('ldnewnew', 'Kd*(1-(1-x/K0)^(-rd/Kd*K0/r0))*(x<l0)');
model.component('comp1').physics('g').prop('ShapeProperty').set('order', 3);
model.component('comp1').physics('g').feature('gfeq1').set('f', {'0'; 'phis*rhos*as*(kapNO3*NO3s)+ (DeNO3*NO3s - AdNO3*NO3)*0'; '- kapNO3*NO3s -(.5*Vmax/(KI2+NO3s))*NO3s + (Vmax/(KN+NH4s))*NH4s'; 'phis*rhos*as*(-UDON*NORG+kapDON*NORGs) + (DeNORG*NORGs - AdNORG*NORG)*0'; 'UDON*NORG  - (Vmax/(KM+NORGs)+kapDON)*NORGs +(.5*Vmax/(KI2+NO3s))*NO3s + (Vmax/(KI1+NH4s))*NH4s'; 'phis*rhos*as*(-UNH4*NH4+kapNH4*NH4s)+(DeNH4*NH4s - AdNH4*NH4 -ANH3*NH4 + BNH3*NH3)*0'; 'UNH4*NH4 - (Vmax/(KN+NH4s)+Vmax/(KI1+NH4s)+kapNH4)*NH4s  + (Vmax/(KM+NORGs))*NORGs + 0*FiN2*N2'; '0'});
model.component('comp1').physics('g').feature('gfeq1').set('Ga', {'(-Gam(p)*(px+(row*g)))'; '(-NO3*(Gam(p))*(px+(row*g))) + (-(Diff(p))*NO3x)'; '-NO3sx*1e-12'; '(-NORG*(Gam(p))*(px+(row*g))) + (-(Diff(p))*NORGx)'; '-NORGsx*1e-12'; '(-NH4*(Gam(p))*(px+(row*g))) + (-(Diff(p))*NH4x)'; '-NH4sx*1e-12'; '-ldx*1e-12'});
model.component('comp1').physics('g').feature('gfeq1').set('da', {'Da(p)';  ...
'NO3*Da(p)';  ...
'0';  ...
'NORG*Da(p)';  ...
'0';  ...
'NH4*Da(p)';  ...
'0';  ...
'0';  ...
'0';  ...
'ST(p)';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'1';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'ST(p)';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'1';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'ST(p)';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'1';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'0';  ...
'1'});
model.component('comp1').physics('g').feature('init1').set('p', '-(9825*x + 19825)');
model.component('comp1').physics('g').feature('init1').set('NO3', 0.43);
model.component('comp1').physics('g').feature('init1').set('NORG', 2);
model.component('comp1').physics('g').feature('init1').set('NH4', 0.07);
model.component('comp1').physics('g').feature('init1').set('ld', 'Kd*(1-(1/(1-l0/K0))^(rd/Kd*K0/r0))*(x<l0)');
model.component('comp1').physics('g').feature('flux1').set('g', {'.9*rn(t)*(1-stepBC(p))*0+int1(t)*(1-stepBC(p))*1.1574e-08+.9*Qs*(1-stepBC(p))*0'; 'gp1(t)/3 + gp2(t)*2/3'; '0'; '0'; '0'; '0'; '0'; '0'});
model.component('comp1').physics('g').feature('dir1').set('r', {'-50000'; '0'; '0'; '2*0'; '0'; '0.07*0'; '0'; '0'});
model.component('comp1').physics('g').feature('dir1').set('useDirichletCondition', [1; 0; 0; 0; 0; 0; 0; 1]);
model.component('comp1').physics('g').feature('dir1').active(false);
model.component('comp1').physics('g').feature('ge1').set('name', 'l0');
model.component('comp1').physics('g').feature('ge1').set('equation', 'l0t - r0*(1-l0/K0)');
model.component('comp1').physics('g').feature('ge1').set('initialValueU', 'introot');
model.component('comp1').physics('g').feature('flux2').set('g', {'(-Gam(p)*((row*g)))'; '(-Gam(p)*((row*g)))*NO3'; '0'; '(-Gam(p)*((row*g)))*NORG'; '0'; '(-Gam(p)*((row*g)))*NH4'; '0'; '0'});
model.component('comp1').physics('g').feature('src1').set('f', {'-(2*pi*a1*kr*ld*(p-pr)+2*pi*a0*kr/(pi*(a0+K1*cos(beta))^2)*(p-pr))*step2(t-2*86400*28*4)'; '-(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-2*86400*28*4)'; '0'; '0'; '0'; '0'; '0'; 'rd*(1-ld/Kd)'});
model.component('comp1').physics('dg').feature('disp2').set('dx', 'l0 - introot');
model.component('comp1').physics('poeq').feature('peq1').set('f', '(p-pr)');
model.component('comp1').physics('poeq').feature('dir1').set('r', 'Pr');

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 2);
model.component('comp1').mesh('mesh1').feature('size').set('table', 'semi');
model.component('comp1').mesh('mesh1').run;

model.study.create('std1');
model.study('std1').create('time', 'Transient');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.result.numerical.create('int1', 'IntLine');
model.result.numerical.create('int2', 'IntLine');
model.result.numerical.create('int3', 'IntLine');
model.result.numerical.create('pev2', 'EvalPoint');
model.result.numerical.create('pev1', 'EvalPoint');
model.result.numerical('int1').selection.set([1 2]);
model.result.numerical('int1').set('probetag', 'none');
model.result.numerical('int2').selection.set([1 2]);
model.result.numerical('int2').set('probetag', 'none');
model.result.numerical('int3').selection.set([1]);
model.result.numerical('int3').set('probetag', 'none');
model.result.numerical('pev2').selection.set([3]);
model.result.numerical('pev2').set('probetag', 'none');
model.result.numerical('pev1').selection.set([3]);
model.result.numerical('pev1').set('probetag', 'none');
model.result.create('pg1', 'PlotGroup1D');
model.result('pg1').create('lngr1', 'LineGraph');
model.result('pg1').feature('lngr1').set('xdata', 'expr');
model.result('pg1').feature('lngr1').selection.set([1]);

model.study('std1').feature('time').set('tlist', 'range(0,50400,9676800)');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('v1').set('clist', {'range(0,50400,9676800)' '9676.800000000001[s]'});
model.sol('sol1').feature('t1').set('tlist', 'range(0,50400,9676800)');
model.sol('sol1').feature('t1').set('atolglobalfactor', 0.001);
model.sol('sol1').feature('t1').set('fieldselection', 'comp1_material_disp');
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_material_disp' 'global' 'comp1_NH4' 'global' 'comp1_NH4s' 'global' 'comp1_NO3' 'global' 'comp1_NO3s' 'global'  ...
'comp1_NORG' 'global' 'comp1_NORGs' 'global' 'comp1_p' 'global' 'comp1_pr' 'global' 'comp1_ODE1' 'global'  ...
'comp1_ld' 'global'});
model.sol('sol1').feature('t1').set('atolvaluemethod', {'comp1_material_disp' 'factor' 'comp1_NH4' 'factor' 'comp1_NH4s' 'factor' 'comp1_NO3' 'factor' 'comp1_NO3s' 'factor'  ...
'comp1_NORG' 'factor' 'comp1_NORGs' 'factor' 'comp1_p' 'factor' 'comp1_pr' 'factor' 'comp1_ODE1' 'factor'  ...
'comp1_ld' 'factor'});
model.sol('sol1').feature('t1').set('atolfactor', {'comp1_material_disp' '0.1' 'comp1_NH4' '0.1' 'comp1_NH4s' '0.1' 'comp1_NO3' '0.1' 'comp1_NO3s' '0.1'  ...
'comp1_NORG' '0.1' 'comp1_NORGs' '0.1' 'comp1_p' '0.1' 'comp1_pr' '0.1' 'comp1_ODE1' '0.1'  ...
'comp1_ld' '0.1'});
model.sol('sol1').feature('t1').set('atol', {'comp1_material_disp' '1e-3' 'comp1_NH4' '1e-3' 'comp1_NH4s' '1e-3' 'comp1_NO3' '1e-3' 'comp1_NO3s' '1e-3'  ...
'comp1_NORG' '1e-3' 'comp1_NORGs' '1e-3' 'comp1_p' '1e-3' 'comp1_pr' '1e-3' 'comp1_ODE1' '1e-3'  ...
'comp1_ld' '1e-3'});
model.sol('sol1').feature('t1').set('atoludot', {'comp1_material_disp' '1e-3' 'comp1_NH4' '1e-3' 'comp1_NH4s' '1e-3' 'comp1_NO3' '1e-3' 'comp1_NO3s' '1e-3'  ...
'comp1_NORG' '1e-3' 'comp1_NORGs' '1e-3' 'comp1_p' '1e-3' 'comp1_pr' '1e-3' 'comp1_ODE1' '1e-3'  ...
'comp1_ld' '1e-3'});
model.sol('sol1').feature('t1').set('tstepsbdf', 'intermediate');
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 100);
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', '.1');
model.sol('sol1').runAll;

model.result.numerical('int1').set('looplevelinput', {'last'});
model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').set('expr', {'NO3'});
model.result.numerical('int1').set('unit', {'m'});
model.result.numerical('int1').set('descr', {'Dependent variable NO3'});
model.result.numerical('int2').set('expr', {'p' 'NO3' 'NO3s' 'NORG' 'NORGs' 'NH4' 'NH4s' 'pr'});
model.result.numerical('int2').set('unit', {'m' 'm' 'm' 'm' 'm' 'm' 'm' 'm'});
model.result.numerical('int2').set('descr', {'' '' '' '' '' '' '' 'Dependent variable pr'});
model.result.numerical('int3').label('uppy');
model.result.numerical('int3').set('table', 'tbl6');
model.result.numerical('int3').set('expr', {'(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-86400*28*4)'});
model.result.numerical('int3').set('unit', {''});
model.result.numerical('int3').set('descr', {''});
model.result.numerical('int3').set('method', 'integration');
model.result.numerical('int3').set('dataseries', 'integral');
model.result.numerical('int3').set('dataseriesmethod', 'integration');
model.result.numerical('pev2').set('table', 'tbl4');
model.result.numerical('pev2').set('expr', {'(-NO3*(Gam(p))*(px+(row*g))) + (-(Diff(p))*NO3x)'});
model.result.numerical('pev2').set('unit', {'1/m'});
model.result.numerical('pev2').set('descr', {''});
model.result.numerical('pev2').set('dataseries', 'integral');
model.result.numerical('pev2').set('dataseriesmethod', 'integration');
model.result.numerical('pev1').set('expr', {'p' 'NO3' 'NO3s' 'NORG' 'NORGs' 'NH4' 'NH4s' 'pr'});
model.result.numerical('pev1').set('unit', {'1' '1' '1' '1' '1' '1' '1' '1'});
model.result.numerical('pev1').set('descr', {'' '' '' '' '' '' '' 'Dependent variable pr'});
model.result.numerical('int1').setResult;
model.result.numerical('int3').setResult;
model.result.numerical('pev2').setResult;
model.result('pg1').set('xlabel', 'x-coordinate (m)');
model.result('pg1').set('ylabel', '(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-2*86400*28*4)');
model.result('pg1').set('xlabelactive', false);
model.result('pg1').set('ylabelactive', false);
model.result('pg1').feature('lngr1').set('expr', '(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-2*86400*28*4)');
model.result('pg1').feature('lngr1').set('unit', '');
model.result('pg1').feature('lngr1').set('descr', '(ld*F1(p, x, t, NO3)+ F0(p, x, t, NO3)/(pi*(a0+ K1*cos(beta))^2))*step2(t-2*86400*28*4)');
model.result('pg1').feature('lngr1').set('xdataexpr', 'x');
model.result('pg1').feature('lngr1').set('xdataunit', 'm');
model.result('pg1').feature('lngr1').set('xdatadescr', 'x-coordinate');
model.result('pg1').feature('lngr1').set('resolution', 'normal');
model.result('pg1').run;
model.result.remove('pg1');

model.label('SuperblobRLD_Master.mph');
model.result.table.create('tbl7', 'Table');
model.result.numerical.create('int4', 'IntLine');
model.result.numerical('int4').selection.set([1 2]);
model.result.numerical('int4').set('probetag', 'none');
model.result.numerical('int4').label('Denif');
model.result.numerical('int4').set('table', 'tbl7');
model.result.numerical('int4').set('expr', {'(NO3+NH4)*(S(p)>=0.63)*(int1(t)<=0.5)'});
model.result.table('tbl7').comments('Denif ((NO3+NH4)*(S(p)>=0.63)*(int(t)<=0.5))');
model.result.numerical('int4').set('unit', {''});
model.result.numerical('int4').set('descr', {''});
model.result.numerical('int4').set('dataseries', 'integral');
model.result.numerical('int4').set('dataseriesmethod', 'integration');
model.result.numerical('int4').setResult;


Tabl_real= model.result.table('tbl1').getReal;
int = Tabl_real(2);

flux = model.result.table('tbl4').getReal;
leachy = int+flux;
uppy = model.result.table('tbl6').getReal;
gas= model.result.table('tbl7').getReal;


%mphsave(model,'SuperblobRLD_out.mph')

out = model;
toc
end
