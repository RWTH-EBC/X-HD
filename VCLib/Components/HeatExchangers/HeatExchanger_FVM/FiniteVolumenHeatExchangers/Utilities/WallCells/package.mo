within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities;
package WallCells "Package that contains different wall cells"
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
This package contains different wall cells used by
finite volume heat exchangers.<br/><br/>
Currently, just one simple wall cell is implemented 
in the package. This wall cell can be used for either 
direct-current or counter-currrent heat exchangers. 
</p>
</html>"));
end WallCells;
