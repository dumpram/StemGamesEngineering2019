
%% Constants

% Densities
row = 1025; % kg/m^3 - Salt water
roc = 7850; % kg/m^3 - Steel
rop = 1300; % kg/m^3 - Plastics

% Physical constants
g = 9.81; % m/s^2

sigma = 125
faktor_zavarivanja = 1
faktor_strukture = 1.5

%% Inputs

max_depth = 100; % m

sub_l = 18 % m - length
R = 1.5 % m - radius

speed_kn = 7






%% Calculations

p_h = row * g * max_depth % Pa - Hydrostatic pressure
p_h_bar = p_h / 100000 % Bar - Hydrostatic pressure


L = sub_l + 2 * R


% Volume

vol_cylinder = R^2 * sub_l * pi; % m^3
vol_sphere = 4/3 * R^3 * pi; % m^3
sub_volume = vol_cylinder + vol_sphere % m^3

istisnina = row * sub_volume % t

CB =  sub_volume / (L * 2 * R * 2 * R) % Block coefficient


% Surface

sur_cylinder = 2 * R * pi * sub_l
sur_sphere =  4 * R^2 * pi

sub_surface = sur_cylinder + sur_sphere

% Debljina stjenke

Di = 2 * R * 1000

sub_stijenka = p_h_bar * Di / (20 * sigma * faktor_zavarivanja + p_h_bar)

sub_masa_celika = sub_surface * sub_stijenka/1000 * roc/1000 * faktor_strukture


% Power

speed_ms = speed_kn * 0.514444;

ni = 0.000001187 % m^2/s - Kinematic vicscosity 
Rn = speed_ms * L / ni % Reynolds_number

CF = 0.075/(log10(Rn)-2)^2 % Friction coefficient

Fn = speed_ms /sqrt(9.08665 * L)


k=-0.095+25.6 *CB/((L/(2*R))^2)

CT = CF * (1 + k)

Re = CT * 0.5 * row * speed_ms^2 * sub_surface / 1000 % kW
Pe = Re * speed_ms % kW
Pb1 = Pe/(0.5*0.98)
Pb= Pb1/0.85



% Stability








