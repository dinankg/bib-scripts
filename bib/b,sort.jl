# b,sort.jl
# sort .b file by year then author

using Printf

# getkey()
function key_get(line, sort_by, bcounter)

	key = split(line, ' ') # separate: @a fessler:00:sir ...

	if key[1][1] != '@'
		throw("bad key = '$(key[1])'")
	end

	if sort_by == "page"
		if (key[1] == "@a") # journal
		#	@warn("key = '$(key[6])'")
			vol = key[4] # volume (for mathprog)
		#	@warn("vol = '$vol'")
			vol = lpad(vol, 5, '0') # pad vol with many zeros for string sort
		#	@warn("vol = '$vol'")
			tmp = split(key[6], '-') # use just first page for sorting
		elseif (key[1] == "@c") # conference
			vol = ""
			tmp = split(key[5], '-') # use just first page for sorting
		else
			@warn("bad key[1] = '$(key[1])'")
			exit(-1)
		end
		if tmp[1][1] == 'C'
			tmp = lpad(tmp[1], 7, '-') # pad left with '-' so "C1" is first
		else
			tmp = lpad(tmp[1], 7, '0') # pad with many zeros for string sort
		end
#		throw("tmp = '$tmp'")
#		return parse(Int32, tmp[1])
		tmp = vol * tmp # concat
		tmp = tmp * @sprintf("%5d", bcounter) # append to make unique (page case)
	#	@warn("tmp = '$tmp'")
		return tmp
	end

	if sort_by != "code"
		@warn("bad sort_by = '$sort_by'")
		exit(-1)
	end

	key = key[2] # fessler:00:sir

	# now reorder as "00 fessler sir"
	parts = split(key, ':')
	rest = join(parts[3:end])
#	@printf "rest = '%s'\n" rest

	# handle y2k issue
	p2 = parts[2]
	if length(p2) == 0 # fessler::abc
		parts[2] = "9999" # force at end
	elseif length(p2) == 2
		key2num = parse(Int, p2)
		if key2num < 50
			key2num = 2000 + key2num
		else
			key2num = 1900 + key2num
		end
		parts[2] = string(key2num)
	elseif length(p2) != 4
		@warn("wierd p2 '$p2' in '$key'")
	end

	key = parts[2] * parts[1] * rest # combine for final sort key

	return key
end


# key_store!
function key_store!(dict, key, par)

	# store key / paragraph in dictionary
	if haskey(dict, key)
		@warn("key '$key' is repeated")
	#	exit(-1)
	end
	dict[key] = par
end


# dict_store!
function dict_store!(dict, par, sort_by, bcounter)
	key = key_get(par, sort_by, bcounter)
	key_store!(dict, key, par)
#	@printf "\nkey = '%s', par = '%s'\n" key par
end



function do_all(filename, sort_by)

#@printf "file = '%s'\n" filename

bcounter = 1
lines = ""

# dictionary
# https://en.wikibooks.org/wiki/Introducing_Julia/Dictionaries_and_sets
#if sort_by == "page"
#	dict = Dict{Int32,String}()
#else
	dict = Dict{String,String}()
#end

#@printf "1 bcounter = '%d'\n" bcounter


# open file and read from it
# https://en.wikibooks.org/wiki/Introducing_Julia/Working_with_text_files

# 2017-07-07 cannot use this "open do" trick with bcounter!?
#open(filename, "r") do fp
fp = open(filename, "r")
	lines = readlines(fp) # read all lines

#	@printf "2 bcounter = '%d'\n" bcounter

	nline = length(lines)
#	@printf "nline = %d\n" nline

	par = "" # initialize empty paragraph

	# group adjacent lines into a paragraph
	for il in 1:nline 
		line = lines[il]
	#	@printf "line[%d] = '%s'\n" il chomp(line)

	#	@printf "3 bcounter = '%d'\n" bcounter

		if length(line) > 0 && line[1] == '#' # skip comment lines
			continue
		end

		if length(line) == 0 || line == "\n" || il == nline # end of paragraph
			if par == "" || par == "\n"
				continue
			end

			par = chomp(par)
		#	@printf "\nstore bcounter= '%s'\n" bcounter
		#	@printf "\npar = '%s'\n" par
		#	@warn("bad par = '$par'")

		#	bcounter = 0
			dict_store!(dict, par, sort_by, bcounter)
			bcounter += 1 # todo
			par = "" # reset back to empty paragraph

		else
			par = par * line * "\n" # append line to par
		end

	#	break 
	end

	# handle last paragraph
	if length(par) > 1
		dict_store!(dict, par, sort_by, bcounter)
	end

close(fp)
#end # auto closes


#@printf "\n#key = %d\n\n" length(keys(dict))

# print sorted
for key in sort(collect(keys(dict)))
#	println("$key => $(dict[key])")
	println("$(dict[key])\n")
end

#=

x = 1 + 3
println("x = %g", x)
@printf "x = %g\n" x

=#

end # do_all


# main here
# println(ARGS[1])

filename = ARGS[1]

if length(ARGS) > 1 && ARGS[1] == "-page" # sort by page instead
	sort_by = "page"
	filename = ARGS[2]
elseif length(ARGS) > 1 && ARGS[2] == "-page" # sort by page instead
	sort_by = "page"
else
	sort_by = "code" # sort by bibtex code
end

do_all(filename, sort_by)
