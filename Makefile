.PHONY: dev test clean build upload upload-test init

init:
	uv venv .venv
	source .venv/bin/activate && uv pip install ".[dev]"
	mkdir -p build

dev:
	@echo "Building and reinstalling..."
	mkdir -p build
	cmake --build build --parallel
	uv pip install . --no-deps --no-build-isolation --config-settings=build-dir=build --force-reinstall

test:
	@echo "Running tests..."
	ctest --output-on-failure --test-dir build

clean:
	rm -rf build dist *.egg-info

build:
	@echo "Building source package..."
	@rm -rf build dist *.egg-info
	python -m build --sdist
	@echo "Building wheels..."
	CIBW_BEFORE_ALL="yum install -y boost-devel CGAL-devel gsl-devel" \
	CIBW_PRINT_BUILD_IDENTIFIERS=1 \
 	cibuildwheel --output-dir dist

upload:
	@echo "Uploading to PyPI..."
	python -m twine check dist/*
	python -m twine upload dist/* --verbose

upload-test:
	@echo "Uploading to Test PyPI..."
	python -m twine check dist/*
	python -m twine upload --repository testpypi dist/* --verbose