within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities;
package HeatTransfers "Package that contains different heat transfer correlations"
  extends Modelica.Icons.VariantsPackage;


  annotation (Documentation(revisions="<html>
<ul>
  <li>
  June 14, 2018, by Friederike Dickel:<br/>
  First implementation
  </li>
</ul>
</html>", info="<html>
<p>
This package contains different modellling approaches of the coefficient of
heat transfer. Currently, the following approaches are implemented within 
this package:
</p>
</p>
<ul>
<li>
<a href=\"modelica://AixLib.Fluid.HeatExchangers.MovingBoundaryHeatExchangers.Utilities.HeatTransfers.ConstantCoefficientOfHeatTransfer\">
ConstantCoefficientOfHeatTransfer:</a> This model provides a constant
coefficient of heat transfer. Thus, it is the most basic model.
</li>
</ul>
</html>"));
end HeatTransfers;
