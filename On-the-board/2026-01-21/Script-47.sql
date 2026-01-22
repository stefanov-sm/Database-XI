select ('[
{
	"name":"Teodor",
	"year_of_birth":1950
},
{
	"name":"Martin",
	"year_of_birth":1927
},
{
	"name":"Viktor",
	"year_of_birth":1800
},
{
	"name":"Daniel",
	"year_of_birth":2025
}
]'::jsonb)[0]['name']::text

-- jsonb == json binary (indexable)
-- in jsonb if you repeat a tag only the last one is perserved
-- single arrow -> extracts as json
-- double arror ->> extracts as text