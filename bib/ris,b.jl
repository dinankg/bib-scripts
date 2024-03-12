# ris,b.jl
# convert RIS file to .b file

using Printf # @printf

# getkey()
function key_get(line)

	parts = split(line, "  -"); # separate TY - JOUR ...

	if length(parts) < 2
		@warn("bad line '$line'\n")
	end

	key = parts[1] # AU TI ...

	rest = join(parts[2:end])
#	@printf "rest = '%s'\n" rest
	while length(rest) > 0 && rest[1] == ' '
		rest = rest[2:end]
	end

	return (key, rest)
end


# key_store!
# store key / rest in dictionary
function key_store!(dict, key, rest)

	if key == "AU" && haskey(dict, key)
		rest = dict["AU"] * "; " * rest # prepend authors
	elseif haskey(dict, key)
		@warn("key '$key' is repeated\n")
	#	exit(-1)
	end

	dict[key] = rest
end


# dict_store!
function dict_store!(dict, line)
	(key, rest) = key_get(line)
	key_store!(dict, key, rest)
#	@printf "\nkey = '%s', rest = '%s'\n" key rest
end


# println(ARGS[1]);

filename = ARGS[1];

#@printf "file = '%s'\n" filename

lines = "";

# dictionary
# https://en.wikibooks.org/wiki/Introducing_Julia/Dictionaries_and_sets
dict = Dict{String,String}();

# open file and read from it
# https://en.wikibooks.org/wiki/Introducing_Julia/Working_with_text_files
# open(filename) do fp
fp = open(filename, "r")
	lines = readlines(fp) # read all lines

	nline = length(lines)
#	@printf "nline = %d\n" nline

	# process each line into dictionary
	for il in 1:nline 
		line = lines[il];
	#	@printf "line[%d] = '%s'\n" il chomp(line)

		if length(line) == 0 || line == "\n" # blank line of paragraph
			continue
		end

		if line[1] == '#' # skip comment lines
			continue
		end

		line = chomp(line)
	#	@printf "\npar = '%s'\n" par
	#	@warn(@sprintf("bad par = '%s'\n", par))

		dict_store!(dict, line)
	end
close(fp)
#end # auto closes

#if haskey(dict, "PY")
#	y2 = get(
#end
y2 = get(dict, "PY", "??") # todo
y4 = get(dict, "PY", "??")

@printf("@a :%s: %s %s %s %s-%s %s %s\n",
	y2,
	get(dict, "JA", "?"),
	get(dict, "VL", "?"),
	get(dict, "IS", "?"),
	get(dict, "SP", "?"),
	get(dict, "EP", "?"),
	"?", y4)
println(dict["AU"])
println(get(dict, "TI", get(dict, "T1", "??")))

doi = get(dict, "UR", "?")
doi = replace(doi, "http://(dx.)?doi.org/" => "")
@printf("@u doi %s\n", doi)

#=

@printf "#key = %d\n" length(keys(dict))

# print sorted
for key in sort(collect(keys(dict)))
#	println("$key => $(dict[key])")
	@printf("'%s' => '%s'\n", key, dict[key])
#	println("$(dict[key])\n")
end

=#
