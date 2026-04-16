# sewanee_weather

Ultimate Question: Who Uses Sewanee's Resources? Are they being efficient?

This project is an interactive Shiny dashboard on utility consumption across Sewanee's residence halls. It covers water, electricity, and natural gas usage by per resident so that different sized halls can be fairly compared.

This can be used by anyone who wants to understand if Sewanee resources are being used efficiently in the halls, if not, which halls, which month, which parameter(water, gas, electricity) is the problem. Once a problem is identified, it is easy to determine the solution because it falls in a structure. This dashboard does exactly that.

This is my data story 4 and the idea was to understand which halls use the most resources, and does that change over time? Intuitively, a bigger hall uses more. But once you divide by the number of residents, that assumption breaks down. Some halls are surprisingly inefficient, and the seasonal patterns are worth exploring.

The dashboard includes two tabs:

- Monthly Time Series: pick a hall, a date range, and a resource metric to see usage trends over time. You can also rank halls by their average consumption to find the biggest users quickly.

- Data Viewer:  the raw cleaned dataset behind every chart, sortable and searchable. This changes based on what sort of data you are viewing.

Here is a screen record of how you can use the dashboard: https://www.loom.com/share/a90146b4a79f4adbaafcd7ae41bf0f86

Data source: Sewanee Office of Facilities Management- monthly utility records for all campus buildings.
