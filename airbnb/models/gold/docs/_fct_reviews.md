{% docs fct_reviews %}
# `fct_reviews`

**Schema:** `gold`
**Materialization:** Incremental (`append`)
**Source models:** `dim_listings`, `dim_hosts`

---

## Overview

`fct_reviews` is the primary fact table for listing-level review analytics. It combines active listing attributes from `dim_listings` with host superhost status from `dim_hosts`, producing a denormalized, analysis-ready grain at the **listing level**.

Only currently active SCD Type 2 records are included (i.e. `end_date = '9999-12-31'`). On incremental runs, only listings updated after the latest `updated_at` already in the table are appended.

---

## Incremental Strategy

| Property | Value |
|---|---|
| Strategy | `append` |
| Incremental filter | `updated_at > max(updated_at)` of existing table |
| Active record filter | `end_date = '9999-12-31'` (current SCD2 records only) |

> **Note:** Because the strategy is `append`, duplicate records are possible if the same `listing_id` is updated multiple times between runs. Consumers should deduplicate on `listing_id` ordered by `updated_at DESC` if they need the latest snapshot.

---

## Sentiment Score Logic

Sentiment is derived from **review-level categorical variables** and aggregated up to the listing level.

### Step 1 — Category to numeric mapping

Each review's sentiment category is mapped to a numeric score:

| Category | Score |
|---|---|
| `positive` | `+1` |
| `neutral` | `0` |
| `negative` | `-1` |

### Step 2 — Aggregate to listing level

Scores are **summed** across all reviews for a given `listing_id`:

```
sentiment_score = SUM(review_score) per listing_id
```

### Step 3 — Min-Max normalization

The raw sum is normalized to a `[0, 1]` range using min-max scaling:

```
sentiment_score_normalized = (sentiment_score - MIN(sentiment_score))
                           / (MAX(sentiment_score) - MIN(sentiment_score))
```

A value of `1.0` represents the most positively reviewed listing in the dataset; `0.0` represents the most negatively reviewed.

---

## Columns

| Column | Type | Description |
|---|---|---|
| `listing_id` | `string` | Primary key. Unique identifier for the listing. |
| `host_id` | `string` | Foreign key to `dim_hosts`. |
| `name` | `string` | Listing name/title. |
| `room_type` | `string` | Type of room (e.g. `Entire home/apt`, `Private room`). |
| `minimum_nights` | `integer` | Minimum number of nights required to book. |
| `price` | `float` | Nightly price of the listing. |
| `is_superhost` | `boolean` | Whether the host holds superhost status at time of record. |
| `reviews_count` | `integer` | Total number of reviews received for the listing. |
| `sentiment_score` | `integer` | Sum of mapped review sentiment scores (`+1`, `0`, `-1`) across all reviews. |
| `sentiment_score_normalized` | `float` | Min-max normalized sentiment score in range `[0, 1]`. |
| `created_at` | `timestamp` | Timestamp when the listing record was first created. |
| `updated_at` | `timestamp` | Timestamp of the last update to the listing record. Used as the incremental watermark. |
| `start_date` | `date` | SCD2 record valid-from date. |
| `end_date` | `date` | SCD2 record valid-to date. `9999-12-31` indicates the current active record. |


---

## Usage Notes

- Always filter `end_date = '9999-12-31'` when joining back to `dim_listings` or `dim_hosts` directly to avoid fan-out from SCD2 history.
- `sentiment_score_normalized` is relative to the full dataset at the time of the last full refresh — interpret with caution after partial incremental runs.
- For host-level aggregations, join to `dim_hosts` on `host_id` with the same `end_date` filter.
{% enddocs %}