within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block OnOffController "On-off controller"

  parameter Real bandwidth(min=0) "Bandwidth around reference signal";

  parameter Boolean pre_y_start=false "Value of pre(y) at initial time";


  Modelica.Blocks.Interfaces.RealInput reference
    "Connector of Real input signal used as reference signal"
    annotation (Placement(transformation(extent={{-140,80},{-100,40}})));

  Modelica.Blocks.Interfaces.RealInput u
    "Connector of Real input signal used as measurement signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,-80}})));

  Modelica.Blocks.Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

initial equation
  pre(y) = pre_y_start;
equation
  y = pre(y) and (u < reference + bandwidth/2) or (u < reference - bandwidth/2);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-92,74},{44,44}},
          lineThickness=0.5,
          textString="reference"),
        Text(
          extent={{-94,-52},{-34,-74}},
          textString="u"),
        Line(points={{-86,-32},{-78,-6},{-60,26},{-34,40},{-12,42},{6,36},{22,
              28},{38,12},{48,-6},{58,-28}},
          color={0,0,127}),
        Line(points={{-88,-2},{-16,18},{72,-12}},
          color={255,0,0}),
        Line(points={{-88,12},{-16,30},{72,0}}),
        Line(points={{-88,-16},{-16,4},{72,-26}}),
        Line(points={{-92,-18},{-66,-18},{-66,-40},{54,-40},{54,-20},{80,-20}},
          color={255,0,255}),
        Ellipse(
          extent={{73,7},{87,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>The block OnOffController sets the output signal <code>y</code> to <code>true</code> when
the input signal <code>u</code> falls below the <code>reference</code> signal minus half of
the bandwidth and sets the output signal <code>y</code> to <code>false</code> when the input
signal <code>u</code> exceeds the <code>reference</code> signal plus half of the bandwidth.</p>
</html>"));
end OnOffController;
