within Buildings.Fluid.FMI;
partial block RoomConvective "Partial block to export a room model as an FMU"

  replaceable package Medium "Medium in the component"
      extends Modelica.Media.Interfaces.PartialMedium;
    model InletAdaptor "Model for exposing a fluid inlet to the FMI interface"

      replaceable package Medium =
          Modelica.Media.Interfaces.PartialMedium
        "Medium model within the source"
         annotation (choicesAllMatching=true);

      parameter Boolean allowFlowReversal = true
        "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

      parameter Boolean use_p_in = true
        "= true to use a pressure from connector, false to output Medium.p_default"
        annotation(Evaluate=true);

      Buildings.Fluid.FMI.Interfaces.Inlet inlet(
        redeclare final package Medium = Medium,
        final allowFlowReversal=allowFlowReversal,
        final use_p_in=use_p_in) "Fluid inlet"
        annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

      Modelica.Fluid.Interfaces.FluidPort_b port_b(
        redeclare final package Medium=Medium) "Fluid port"
                    annotation (Placement(
            transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
                {110,10}})));
      Modelica.Blocks.Interfaces.RealOutput p(unit="Pa") if
         use_p_in "Pressure"
      annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-110})));
    protected
      Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
        redeclare final package Medium = Medium)
        "Internal connector for fluid properties for back flow";
      Buildings.Fluid.FMI.Interfaces.PressureOutput p_in_internal
        "Internal connector for pressure";
      Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_in_internal
        "Internal connector for mass fraction of forward flow properties";
      Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_out_internal
        "Internal connector for mass fraction of backward flow properties";
    initial equation
       assert(Medium.nXi < 2,
       "The medium must have zero or one independent mass fraction Medium.nXi.");
    equation
      // To locally balance the model, the pressure is only imposed at the
      // outlet model.
      // The sign is negative because inlet.m_flow > 0
      // means that fluid flows out of this component
      -port_b.m_flow     = inlet.m_flow;

      port_b.h_outflow  = Medium.specificEnthalpy_pTX(
                            p=  p_in_internal,
                            T=  inlet.forward.T,
                            X=  fill(X_w_in_internal, Medium.nXi));

      port_b.C_outflow  = inlet.forward.C;

      // Conditional connector for mass fraction for forward flow
      if Medium.nXi == 0 then
        X_w_in_internal = 0;
      else
        connect(X_w_in_internal, inlet.forward.X_w);
      end if;
      port_b.Xi_outflow = fill(X_w_in_internal, Medium.nXi);

      // Conditional connector for flow reversal
      connect(inlet.backward, bacPro_internal);

      // Mass fraction for reverse flow
      X_w_out_internal = if Medium.nXi > 0 and allowFlowReversal then inStream(port_b.Xi_outflow[1]) else 0;
      connect(bacPro_internal.X_w, X_w_out_internal);

      if allowFlowReversal then
        bacPro_internal.T  = Medium.temperature_phX(
                               p=  p_in_internal,
                               h=  inStream(port_b.h_outflow),
                               X=  inStream(port_b.Xi_outflow));
        bacPro_internal.C  = inStream(port_b.C_outflow);
      else
        bacPro_internal.T  = Medium.T_default;
        bacPro_internal.C  = fill(0, Medium.nC);
      end if;

      // Conditional connectors for pressure
      if use_p_in then
      connect(inlet.p, p_in_internal);
      else
        p_in_internal = Medium.p_default;
      end if;
      connect(p, p_in_internal);

      annotation (defaultComponentName="bouInl",
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
            Rectangle(
              extent={{60,60},{-60,-60}},
              lineColor={0,0,0},
              fillPattern=FillPattern.Sphere,
              fillColor={0,127,255}),
            Text(
              extent={{-150,110},{150,150}},
              textString="%name",
              lineColor={0,0,255}),
            Line(
              points={{-100,0},{-60,0}},
              color={0,0,255}),
            Ellipse(
              extent={{-34,30},{26,-30}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{60,20},{100,-21}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={0,127,255}),
            Polygon(
              points={{-18,26},{26,0},{-18,-26},{-18,26}},
              lineColor={0,0,255},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-20,6},{14,-12}},
              lineColor={255,0,0},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid,
              textString="m"),
            Ellipse(
              extent={{-6,8},{-2,4}},
              lineColor={255,0,0},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-120,34},{-98,16}},
              lineColor={0,0,255},
              textString="inlet"),
            Line(
              points={{0,-100},{0,-60}},
              color={0,0,255},
              smooth=Smooth.None),
            Text(
              extent={{2,-76},{24,-94}},
              lineColor={0,0,255},
              textString="p")}),
        Documentation(info="<html>
<p>
Model that is used to connect an input signal to a fluid port.
The model needs to be used in conjunction with an instance of
<a href=\"modelica://Buildings.Fluid.FMI.OutletAdaptor\">
Buildings.Fluid.FMI.OutletAdaptor</a> in order for
fluid mass flow rate and pressure to be properly assigned to
the acausal fluid models.
</p>
<p>
See 
<a href=\"modelica://Buildings.Fluid.FMI.TwoPortComponent\">
Buildings.Fluid.FMI.TwoPortComponent</a>
or
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.ResistanceVolume\">
Buildings.Fluid.FMI.Examples.FMUs.ResistanceVolume</a>
for how to use this model.
</p>
</html>",     revisions="<html>
<ul>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
April 15, 2015 by Michael Wetter:<br/>
Changed connector variable to be temperature instead of
specific enthalpy.
</li>
<li>
January 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics));
    end InletAdaptor;
  end Medium
      annotation (choicesAllMatching = true);

  // Set allowFlowReversal = false to remove the backward connector.
  // This is done to avoid that we get the same zone states multiple times.
  Interfaces.Inlet supAir[size(theHvaAda.supAir, 1)](
    redeclare each final package Medium = Medium,
    each final use_p_in=false,
    each final allowFlowReversal=false)
    "Supply air connectorSupply air connectorFluid outlet"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));

  Modelica.Blocks.Interfaces.RealOutput TAirZon(final unit="K", displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-160,80},{-200,120}})));
  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    each final unit = "kg/kg") if
       Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{-160,40},{-200,80}})));
  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-160,0},{-200,40}})));

  Modelica.Blocks.Interfaces.RealOutput TRadZon(
    final unit="K",
    displayUnit="degC") "Radiative temperature of the zone"
    annotation (Placement(transformation(
          extent={{-160,-40},{-200,0}})));

  Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}})));

  Modelica.Blocks.Interfaces.RealInput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}})));

  Modelica.Blocks.Interfaces.RealInput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}})));

  HVACAdaptor theHvaAda(redeclare final package Medium = Medium, nPorts=1)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{-98,122},{-118,142}})));

equation
  connect(TAirZon, theHvaAda.TZon) annotation (Line(points={{-180,100},{-160,
          100},{-140,100},{-140,135.333},{-120,135.333}},
                                                     color={0,0,127}));
  connect(X_wZon, theHvaAda.X_wZon) annotation (Line(points={{-180,60},{-160,60},
          {-134,60},{-134,132},{-120,132}}, color={0,0,127}));
  connect(CZon, theHvaAda.CZon) annotation (Line(points={{-180,20},{-154,20},{
          -128,20},{-128,128.667},{-120,128.667}},
                                              color={0,0,127}));
  connect(TRadZon, theHvaAda.TRad) annotation (Line(points={{-180,-20},{-150,
          -20},{-124,-20},{-124,125.333},{-120,125.333}},
                                                     color={0,0,127}));
  connect(QGaiRad_flow, theHvaAda.QGaiRad_flow) annotation (Line(points={{-180,
          -60},{-102,-60},{-102,120.333}},
                                      color={0,0,127}));
  connect(QGaiCon_flow, theHvaAda.QGaiCon_flow) annotation (Line(points={{-180,
          -100},{-108,-100},{-108,120.333}},
                                       color={0,0,127}));
  connect(QGaiLat_flow, theHvaAda.QGaiLat_flow) annotation (Line(points={{-180,
          -140},{-114,-140},{-114,120.333}},
                                       color={0,0,127}));
  connect(theHvaAda.supAir, supAir) annotation (Line(points={{-119,138.667},{
          -142.5,138.667},{-142.5,140},{-170,140}},  color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={Rectangle(
          extent={{-160,160},{160,-160}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineColor={0,0,0}),
        Text(
          extent={{-156,-14},{-106,-34}},
          lineColor={0,0,127},
          textString="TRadZon"),
        Text(
          extent={{-158,-50},{-108,-70}},
          lineColor={0,0,127},
          textString="QRad"),
        Text(
          extent={{-158,-88},{-108,-108}},
          lineColor={0,0,127},
          textString="QCon"),
        Text(
          extent={{-162,-128},{-112,-148}},
          lineColor={0,0,127},
          textString="QLat"),
        Text(
          extent={{-158,28},{-108,8}},
          lineColor={0,0,127},
          textString="CZon"),
        Text(
          extent={{-154,70},{-104,50}},
          lineColor={0,0,127},
          textString="X_wZon"),
        Text(
          extent={{-156,110},{-106,90}},
          lineColor={0,0,127},
          textString="TAirZon")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>Model that is used as a container for a thermal zone that is to be exported as an FMU. </p>
<h4>Typical use and important parameters</h4>
<p>To use this model as a container for an FMU, simply extend from this model, rather than instantiate it, and add your thermal zone. By extending from this model, the top-level signal connectors on the left stay at the top-level, and hence will be visible at the FMI interface. The example <a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.RoomConvective\">Buildings.Fluid.FMI.Examples.FMUs.RoomConvective</a> shows how a simple convective thermal zone system can be implemented and exported as an FMU. The example xxxx shows conceptually how such an FMU can then be connected to a room model that has signal flow. </p>
<p>The conversion between the fluid ports and signal ports is done in the HVAC adapter <code>theHvaAda</code>. </p>
<h4>Assumption and limitations</h4>
<p>The mass flow rates at <code>ports</code> sum to zero, hence this model conserves mass. </p>
<p>This model does not impose any pressure, other than setting the pressure of all fluid connections to <code>ports</code> to be equal. The reason is that setting a pressure can lead to non-physical system models, for example if a mass flow rate is imposed and the thermal zone modelis connected to a model that sets a pressure boundary condition such as <a href=\"modelica://Buildings.Fluid.Sources.Outside\">Buildings.Fluid.Sources.Outside</a>. </p>
<h4>Typical use and important parameters</h4>
<p>See <a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">Buildings.Fluid.FMI.RoomConvective</a> for a model that uses this model. </p>
</html>", revisions="<html>
<ul>
<li>April 27, 2016, by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"));
end RoomConvective;
