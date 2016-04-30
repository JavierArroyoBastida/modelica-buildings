within Buildings.Fluid.FMI.Examples.FMUs.Validation;
block RoomConvective "Simple thermal zone"
  extends Buildings.Fluid.FMI.RoomConvective(
    redeclare final package Medium = MediumA, theHvaAda);

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  Modelica.Blocks.Sources.Constant rooAir(k=295.13)
    annotation (Placement(transformation(extent={{120,30},{100,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{84,30},{64,50}})));
  Modelica.Blocks.Sources.Constant radTem(k=295.13)
    annotation (Placement(transformation(extent={{40,90},{20,110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-2,90},{-22,110}})));
  Sources.FixedBoundary       boundary(
    redeclare package Medium = MediumA,
    T=293.15,
    nPorts=2) "Boundary condition"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=285.13)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,100})));
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

 //  parameter Integer nPorts = nPorts;

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal= 0.01;
  /////////////////////////////////////////////////////////
  // HVAC models
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={-60,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,180})));
equation
  connect(rooAir.y, TAir.T)
    annotation (Line(points={{99,40},{99,40},{86,40}},       color={0,0,127}));
  connect(radTem.y, TRad.T)
    annotation (Line(points={{19,100},{19,100},{0,100}}, color={0,0,127}));
  connect(TRad.port, theHvaAda.heaPorRad) annotation (Line(points={{-22,100},{
          -40,100},{-40,125.333},{-97.8,125.333}}, color={191,0,0}));
  connect(TAir.port, theHvaAda.heaPorAir) annotation (Line(points={{64,40},{52,
          40},{52,138.333},{-98,138.333}}, color={191,0,0}));
  connect(boundary.ports[1:2], theHvaAda.ports) annotation (Line(points={{100,
          -2},{100,0},{-48,0},{-48,132},{-98,132}}, color={0,127,255}));
  connect(TDryBul.y, TOut) annotation (Line(points={{99,100},{80,100},{80,148},
          {-60,148},{-60,180}}, color={0,0,127}));
    annotation(Dialog(tab="Assumptions"), Evaluate=true,
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={Line(points={{-80,160},{-80,146}}, color={28,
              108,200}),
        Text(
          extent={{-62,152},{-12,132}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{100,46},{150,26}},
          lineColor={0,0,127},
          textString="CZon"),
        Text(
          extent={{98,90},{148,70}},
          lineColor={0,0,127},
          textString="X_wZon"),
        Text(
          extent={{98,116},{148,96}},
          lineColor={0,0,127},
          textString="TAirZon")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p><span style=\"font-family: Sans Serif;\">This example validates that <a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">Buildings.Fluid.FMI.RoomConvective</a> exports correctly as an FMU.</span></p>
</html>", revisions="<html>
<ul>
<li>April 28, 2016 by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Validation/RoomConvective.mos"
        "Export FMU"));
end RoomConvective;
