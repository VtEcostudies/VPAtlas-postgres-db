SELECT * FROM vpsurvey
WHERE 
(COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibEdgeWOFR', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibEdgeSPSA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibEdgeJESA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibEdgeBLSA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibInteriorWOFR', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibInteriorSPSA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibInteriorJESA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'1'->>'surveyAmphibInteriorBLSA', '0')::int > 0 OR

COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibEdgeWOFR', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibEdgeSPSA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibEdgeJESA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibEdgeBLSA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibInteriorWOFR', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibInteriorSPSA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibInteriorJESA', '0')::int > 0 OR
COALESCE("surveyAmphibJson"->'2'->>'surveyAmphibInteriorBLSA', '0')::int > 0)