SELECT c1.concept_id AS concept_id,
  cast(num_stratum_4 * 10 AS VARCHAR) + '-' + cast((num_stratum_4 + 1) * 10 - 1 AS VARCHAR) AS trellis_name,
	c2.concept_name AS series_name,
	num_stratum_2 AS x_calendar_year,
	ROUND(1000 * (1.0 * num_count_value / denom_count_value), 5) AS y_prevalence_1000pp
FROM (
	SELECT CAST(num.stratum_1 AS INT) AS num_stratum_1,
		CAST(num.stratum_2 AS INT) AS num_stratum_2,
		CAST(num.stratum_3 AS INT) AS num_stratum_3,
		CAST(num.stratum_4 AS INT) AS num_stratum_4,
		num.count_value AS num_count_value,
		denom.count_value AS denom_count_value
	FROM (
		SELECT *
		FROM ACHILLES_results
		WHERE analysis_id = 1004 AND stratum_3 IN ('8507','8532')
		) num
	INNER JOIN (
		SELECT *
		FROM ACHILLES_results
		WHERE analysis_id = 116 AND stratum_3 IN ('8507','8532')
		) denom
		ON num.stratum_2 = denom.stratum_1
			AND num.stratum_3 = denom.stratum_2
			AND num.stratum_4 = denom.stratum_3
	) tmp
INNER JOIN @cdmSchema.dbo.concept c1
	ON num_stratum_1 = c1.concept_id
INNER JOIN @cdmSchema.dbo.concept c2
	ON num_stratum_3 = c2.concept_id
ORDER BY c1.concept_id,
	num_stratum_2
