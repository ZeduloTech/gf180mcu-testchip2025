# Pytest config

def pytest_addoption(parser):
    parser.addoption("--test", action="append", default=[], help="Add Caravel test to run")

def pytest_generate_tests(metafunc):
    if ("test" in metafunc.fixturenames) and metafunc.config.getoption("test"):
        tests = metafunc.config.getoption("test")
    else:
        tests = ["all"]

    if "all" in tests:
        tests = ["wbcounter", "hkspi", "mprj_bitbang", "uart", "pll"]
    
    metafunc.parametrize("test", tests)
