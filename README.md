# Som Cluster Shiny Operator

##### Description

The `Som Cluster Shiny Operator` is a Tercen operator for performing data clustering using self-organizing maps. The operator is a wrapper for the R-package `kohonen`. It allows the user to set the som grid (and hence the number of clusters) interactively while inspecting visuals. 

##### Usage

Input projection|.
---|---

`y-axis`        | numeric, data values
`row`           | factor, factor(s) identifying single observations
`column`        | factor, factor(s) identifying single variables
`colors`        | factor, one or more optional factor(s) that can be used for grouping observations, used for coloring 
`labels`        | factor, a single factor that identifies the variables. If present it is used in the visuals.

Output relations|.
---|---
`cluster`|cluster number for each observation
`Operator view`        | view of the Shiny application

##### Reference

This operator uses the R-package `kohonen`

- Wehrens R, Kruisselbrink J (2018). “Flexible Self-Organizing Maps in kohonen 3.0.” _Journal of
Statistical Software_, *87*(7), 1-18. doi: 10.18637/jss.v087.i07 (URL:
https://doi.org/10.18637/jss.v087.i07).

- Wehrens R, Buydens LMC (2007). “Self- and Super-Organizing Maps in R: The kohonen Package.”
_Journal of Statistical Software_, *21*(5), 1-19. doi: 10.18637/jss.v021.i05 (URL:
https://doi.org/10.18637/jss.v021.i05).



