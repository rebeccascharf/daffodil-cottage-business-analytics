# Tableau Dashboard Build Plan

## Project Title
**Daffodil Cottage Co. Pet Services Business Performance Dashboard**

## Tableau Data Model
Connect to `Daffodil_Cottage_Relational_Tableau_SQL_Dataset.xlsx` and add each sheet as a separate logical table.

## Recommended Relationships

| Table 1 | Key | Table 2 | Key |
|---|---|---|---|
| Transactions | Client_ID | Clients | Client_ID |
| Transactions | Dog_ID | Dogs | Dog_ID |
| Transactions | Service_ID | Services | Service_ID |
| Transactions | Service_Date | Calendar | Date |
| Clients | City_Zone_ID | City_Zones | City_Zone_ID |
| Transactions | Campaign_ID | Marketing_Campaigns | Campaign_ID |

## Dashboard 1: Executive Overview

KPI cards:
- Total Revenue: $91,005.17
- Gross Profit: $62,971.35
- Transactions: 812
- Clients: 125
- Dogs Served: 166

Recommended visuals:
- Monthly revenue line chart
- Revenue by service category bar chart
- Gross profit by service category bar chart
- Payment status bar chart
- Follow-up required KPI

## Dashboard 2: Service Performance

Recommended visuals:
- Revenue by service category
- Gross margin by service category
- Service demand by transaction count
- Trainer hours by service category
- Travel miles by service category

Business question answered:
> Which services make the most money, and which services are most operationally demanding?

## Dashboard 3: Client & Dog Insights

Recommended visuals:
- Top 10 clients by revenue
- Client value segments
- Dog behavior issue distribution
- Household type distribution
- Satisfaction and training outcome view

Business question answered:
> Which client and dog profiles represent the strongest retention and training opportunities?

## Dashboard 4: Marketing & Geography

Recommended visuals:
- Revenue by acquisition channel
- Revenue per client by acquisition channel
- Campaign ROI bar chart
- City-zone map using latitude and longitude
- Revenue by market type

Business question answered:
> Where should the business focus marketing and expansion efforts?

## Dashboard 5: Operations Follow-Up

Recommended visuals:
- Pending payments table
- Follow-up required by service category
- Follow-up required by training outcome
- Trainer hours trend
- Travel mileage trend

Business question answered:
> What needs action operationally, and where can service delivery improve?

## Calculated Fields to Create in Tableau

### Gross Margin
```text
SUM([Gross Profit]) / SUM([Revenue])
```

### Revenue Per Client
```text
SUM([Revenue]) / COUNTD([Client ID])
```

### Client Value Segment
```text
IF { FIXED [Client ID] : SUM([Revenue]) } >= 1000 THEN "High Value"
ELSEIF { FIXED [Client ID] : SUM([Revenue]) } >= 500 THEN "Mid Value"
ELSE "Starter"
END
```

### Payment Collection Flag
```text
IF [Payment Status] = "Pending" THEN "Needs Collection"
ELSE "Paid"
END
```

### Follow-Up Flag
```text
IF [Follow Up Required] = "Yes" THEN "Needs Follow-Up"
ELSE "No Follow-Up"
END
```

## Suggested Portfolio Story

Daffodil Cottage Co. needed a clear way to understand which services, clients, locations, and marketing channels were driving the strongest business results. I built a relational dataset and analyzed revenue, profitability, client acquisition, and operational follow-up needs using SQL and Tableau. The dashboard identifies training as the top revenue and gross-profit category, highlights referral as the strongest acquisition channel, and shows where follow-up and payment collection require attention.
