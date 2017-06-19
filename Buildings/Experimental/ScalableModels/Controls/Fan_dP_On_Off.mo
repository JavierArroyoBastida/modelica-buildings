within Buildings.Experimental.ScalableModels.Controls;
block Fan_dP_On_Off "Controller for fan on/off, and provide prescribced dP"
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.PressureDifference dP_pre=850
    "Prescribed pressure difference";
  Examples.VAVReheat.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Modelica.Blocks.Routing.Extractor extractor(
    nin=6,
    index(start=1, fixed=true)) "Extractor for control signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Constant on(k=dP_pre)
                                           "On signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Interfaces.RealOutput y "Supply fan ON/OFF"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(off.y, extractor.u[Integer(OperationModes.unoccupiedOff)])  annotation (Line(
      points={{-19,-40},{0,-40},{0,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, extractor.u[Integer(OperationModes.safety)])  annotation (Line(
      points={{-19,-40},{0,-40},{0,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.unoccupiedNightSetBack)]) annotation (Line(
      points={{-19,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.occupied)]) annotation (Line(
      points={{-19,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.unoccupiedWarmUp)]) annotation (Line(
      points={{-19,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on.y, extractor.u[Integer(OperationModes.unoccupiedPreCool)]) annotation (Line(
      points={{-19,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(controlBus.controlMode, extractor.index) annotation (Line(
      points={{-60,80},{-60,-20},{30,-20},{30,-12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(extractor.y, y) annotation (Line(points={{41,0},{41,0},{60,0},{110,0}},
                       color={0,0,127}));
  annotation ( Icon(graphics={  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                              Text(
          extent={{-90,-50},{96,-96}},
          lineColor={0,0,255},
          textString="prescribed_dP=%dP_pre"),
                                        Text(
        extent={{-120,140},{120,104}},
        textString="%name",
        lineColor={0,0,255})}),             Documentation(revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.<br/>
</li>
</ul>
</html>"));
end Fan_dP_On_Off;
