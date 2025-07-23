# pyscan-stats

**[pyscan-stats](https://pypi.org/project/pyscan-stats/)** is a Python package for spatial scan statistics, created from a fork of the original **[pyscan](https://github.com/michaelmathen/pyscan)** library by Michael Matheny.

Original repository: [michaelmathen/pyscan](https://github.com/michaelmathen/pyscan)
Original documentation: [https://michaelmathen.github.io/pyscan/](https://michaelmathen.github.io/pyscan/)
Updated examples with data: [https://github.com/simonpedrogonzalez/pyscan-stats-resources](https://github.com/simonpedrogonzalez/pyscan-stats-resources)

# Dev installation

Clone the repository and run:
- `make init`: initialize repository (`uv` package manager required)
- `make dev`: compiles C++ code and install the Python package in development mode
- `make test`: runs the tests
- `make build`: builds distribution wheels

# About pyscan

Pyscan is a python wrapper around a large number of anomaly detection algorithms written in c++. These algorithms are from several papers by Jeff M. Phillips, Michael Matheny, Dong Xie, Mingxuan Han, Raghvendra Singh, Liang Zhang, Kaiqiang Wang, Deepak Agarwal, Andrew McGregor, Suresh Venkatasubramanian and Zhengyuan Zhu:

* [The Kernel Scan Statistic](https://arxiv.org/abs/1906.09381)
* [Scalable Spatial Scan Statistics for Trajectories](https://arxiv.org/abs/1906.01693)
* [Computing Approximate Statistical Discrepancy](https://arxiv.org/abs/1804.11287)
* [Scalable Spatial Scan Statistics through Sampling](https://dl.acm.org/citation.cfm?id=2996939)
* [Spatial Scan Statistics: Approximations and Performance Studies](http://www.cs.utah.edu/~jeffp/papers/stat-disc-KDD06.pdf)
* [The Hunting of the Bump: On Maximizing Statistical Discrepancy](http://www.cs.utah.edu/~jeffp/papers/stat-disc-SODA06.pdf)

