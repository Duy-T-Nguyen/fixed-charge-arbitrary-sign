.PHONY: check build clean-build versions

check:
	bash scripts/check_no_holes.sh
	LEAN_NUM_THREADS=4 lake build
	lake env lean FixedCharge/Audit.lean
	lake env lean FixedChargeCore.lean
	LEAN_NUM_THREADS=4 lake build +FixedCharge.Tests.FiniteOpt +FixedCharge.Tests.Model
	LEAN_NUM_THREADS=4 lake build +FixedCharge.Paper1.Witnesses

build:
	LEAN_NUM_THREADS=4 lake build

clean-build:
	lake clean fixed-charge
	LEAN_NUM_THREADS=4 lake build

versions:
	lean --version
	lake --version
	lake env lean --version
