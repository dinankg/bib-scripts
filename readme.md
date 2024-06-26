bib-scripts

https://github.com/JeffFessler/bib-scripts

The `bib/` directory here
contains some `csh` and `perl` scripts
for processing `.bib` files
associated with `BiBTeX`
collected over >30 years of research.
Only a few of them are useful.

- `b,bib` converts from a personal concise format
  to the `BiBTeX` format.

For example if file `example.b2` contains
```
@b fessler:24:laf Cambridge . 2024
J A Fessler  Raj Rao Nadakuditi
Linear algebra for data science, machine learning, and signal processing
@u http://www.cambridge.org/highereducation/isbn/9781009418140
@doi 10.1017/9781009418164
@note To appear

@a fessler:20:omf ieee-spmag 37 1 33-40 jan 2020
J A Fessler
Optimization methods for MR image reconstruction
@doi 10.1109/MSP.2019.2943645
@an some notes
```

Then running `b,bib example.b2` at shell prompt produces the output

```
@BOOK{fessler:24:laf,
 author = {J. A. Fessler and R. R. Nadakuditi},
 title = {Linear algebra for data science, machine learning, and signal processing},
 publisher = {Cambridge},
 note = {To appear},
 doi = {10.1017/9781009418164},
 year = 2024
}

@ARTICLE{fessler:20:omf,
 author = {J. A. Fessler},
 title = {Optimization methods for {MR} image reconstruction},
 journal = {{IEEE Sig. Proc. Mag.}},
 volume = 37,
 number = 1,
 pages = {{33--40}},
 month = jan,
 doi = {10.1109/MSP.2019.2943645},
 year = 2020
}
```

- `bib,b2` does the reverse (converts `.bib` format to concise format)

- `@doi` opens the given doi in a browser

Disclaimer:
There are probably missing files and inconvenient "hard-wired" shell paths.


The examples above illustrate my personal BiBTeX key style
(that I probably learned from someone at Stanford):
last name of first author,
then the year (2 digits if after 1950, four digits if before),
then the first letter of the first three words in the title.
So "Optimization methods for ..." in 2020 becomes `:20:omf`.
If I were starting over today I would use 4 digits
and I might consider `2020:fessler:omf`
because as papers go from preprints to publications
the year usually changes
whereas the author and title change less often.
So I could grep for `fessler:omf` and find it
even if the year has changed.
