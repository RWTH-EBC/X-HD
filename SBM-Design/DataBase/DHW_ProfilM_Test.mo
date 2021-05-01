within Configurations.DataBase;
model DHW_ProfilM_Test
  extends Modelica.Blocks.Sources.CombiTimeTable(table=[3600,0; 25200,100;
        25230,0; 26100,100; 26538,0; 27000,100; 27030,0; 28860,100;
        28890,0; 29700,100; 29730,0; 30600,100; 30630,0; 31500,100; 31530,
        0; 32400,100; 32430,0; 34200,100; 34230,0; 37800,100; 37830,0;
        41400,100; 41430,0; 42300,100; 42330,0; 45900,100; 45966,0;
        52200,100; 52230,0; 55800,100; 55830,0; 59400,100; 59430,0; 64800,
        100; 64830,0; 65700,100; 65724,0; 66600,100; 66624,0; 68400,100;
        68430,0; 73800,100; 74010,0; 76500,100; 76530,0; 77400,100;
        77838,0; 86400,0], startTime=21600,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic);
end DHW_ProfilM_Test;
