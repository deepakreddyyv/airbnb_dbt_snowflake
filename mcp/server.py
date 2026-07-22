from fastmcp import FastMCP
import subprocess
from typing import Annotated
from pydantic import Field


mcp = FastMCP("My dbt Server")

METRICFLOW = "/Users/deepak.reddy/programs/airbnb-analytics/.venv/bin/mf"


@mcp.tool(
        name="list_metrics",
        description="List all metrics in the dbt project. "
                    "Use this when you want to see all the metrics and dimensions available in the dbt project"
)
def list_metrics() -> str:
    """List all metrics in the dbt project"""
    result = subprocess.run(
        f"cd /Users/deepak.reddy/programs/airbnb-analytics/airbnb && {METRICFLOW} list metrics --show-all-dimensions",
        shell=True,
        capture_output=True,
        text=True
    )
    return result.stdout

@mcp.tool(
        name="query_metric",
        description="Query a specific metric in the dbt project. "
                    "Use this when you want to query a specific metric and get the results"
                    "make sure you have the correct metric name and dimensions available in the dbt project"
                    "You can use the list_metrics tool to see all the metrics and dimensions available in the dbt project"
)
def query_metric(
    metric_name: Annotated[str, Field(description="The name of the metric to query")],
    groupby: Annotated[str, Field(description="The dimension to group by")] = None,
    orderby: Annotated[str, Field(description="The dimension to order by")] = None
) -> str:
    """Query a specific metric in the dbt project."""
    q = f"{METRICFLOW} query --metrics {metric_name}"
    if groupby:
        q += f" --group-by {groupby}"
    if orderby:
        q += f" --order {orderby}"
    result = subprocess.run(
        f"cd /Users/deepak.reddy/programs/airbnb-analytics/airbnb && {q}",
        shell=True,
        capture_output=True,
        text=True
    )
    return result.stdout + result.stderr


if __name__ == "__main__":
    mcp.run()