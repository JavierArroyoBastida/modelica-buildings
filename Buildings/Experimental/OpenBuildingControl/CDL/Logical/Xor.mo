within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Xor "Logical 'xor': y = u1 xor u2"

  Modelica.Blocks.Interfaces.BooleanInput u1 "Connector of first Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanInput u2
    "Connector of second Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = not ((u1 and u2) or (not u1 and not u2));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={      Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
                                   Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="xor"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-6},{-89,8}},
          lineColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-73},{-89,-87}},
          lineColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}),
                               Documentation(info="<html>
<p>
The output is <code>true</code> if exactly one input is <code>true</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end Xor;
