function I = Initiator


%% Design Weight

I.Weight.MTOW    =  20820;            
I.Weight.ZFW   =  16000;          
I.n_max = 2.5;

%% Wing Geometry
 
I.Wing(1).Area    =  61.25; 
I.Wing(1).Span     =  28;     
I.Wing(1).SectionNumber =2;
I.Wing(1).AirfoilNumber =2;

I.Wing(1).AirfoilName = {'E553' 'E553'};
I.Wing(1).AirfoilPosition = [0 1];


% section 1

I.Wing(1).WingSection.Chord=3.5;
I.Wing(1).WingSection.Xle=0;
I.Wing(1).WingSection.Yle=0;
I.Wing(1).WingSection.Zle=0;
I.Wing(1).WingSection.FrontSparPosition=0.20;
I.Wing(1).WingSection.RearSparPosition=0.80;


% section 2

I.Wing(2).WingSection.Chord=3.5*0.25;
I.Wing(2).WingSection.Xle=0+28/2*tand(5);
I.Wing(2).WingSection.Yle=28/2;
I.Wing(2).WingSection.Zle=0;
I.Wing(2).WingSection.FrontSparPosition=0.20;
I.Wing(2).WingSection.RearSparPosition=0.80;



%% fuel tanks geometry

I.WingFuelTank.Ystart = 0.1;
I.WingFuelTank.Yend = 0.7;


%% Power plant and landing gear and wing atructure
   
I.PP(1).WingEngineNumber   =   1;  
I.PP(1).EnginePosition = 0.25;
I.PP(1).EngineWeight = 1200;


%% Material and Structure

I.Material.Wing.UpperPanel.E = 7.1e10;
I.Material.Wing.UpperPanel.rho =2800;
I.Material.Wing.UpperPanel.Sigma_tensile = 4.8e8;
I.Material.Wing.UpperPanel.Sigma_compressive = 4.6e8;

I.Material.Wing.LowerPanel.E = 7.1e10;
I.Material.Wing.LowerPanel.rho = 2800;
I.Material.Wing.LowerPanel.Sigma_tensile = 4.8e8;
I.Material.Wing.LowerPanel.Sigma_compressive = 4.6e8;

I.Material.Wing.FrontSpar.E = 7.1e10;
I.Material.Wing.FrontSpar.rho = 2800;
I.Material.Wing.FrontSpar.Sigma_tensile = 4.8e8;
I.Material.Wing.FrontSpar.Sigma_compressive = 4.6e8;

I.Material.Wing.RearSpar.E = 7.1e10;
I.Material.Wing.RearSpar.rho = 2800;
I.Material.Wing.RearSpar.Sigma_tensile =4.8e8;
I.Material.Wing.RearSpar.Sigma_compressive = 4.6e8;


I.Structure.Wing.UpperPanelEfficiency=0.96;  
I.Structure.Wing.RibPitch =0.5;







