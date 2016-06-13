within Buildings.Fluid.HeatExchangers.ActiveBeams.Data;
record TroxDID632A_nozzleH_lenght6ft_coo =
  Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic_coo (
    primaryair(Normalized_AirFlow={0,0.714286,1,1.2857}, ModFactor={0,0.823403,
          1,1.1256}),
    water(Normalized_WaterFlow={0,0.33333,0.5,0.666667,0.833333,1,1.333333},
        ModFactor={0,0.71,0.85,0.92,0.97,1,1.04}),
    temp_diff(Normalized_TempDiff={0,0.5,1}, ModFactor={0,0.5,1}),
    mAir_flow_nominal=0.0792,
    mWat_flow_nominal_coo=0.094,
    temp_diff_nominal_coo=-10,
    Q_flow_nominal_coo=-1092);
