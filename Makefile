dev:
	ghcid --command "stack ghci --ghci-options -fdiagnostics-color=always" --test "DevMain.run"
.PHONY: dev

test:
	ghcid --command "stack ghci enkuber:lib :enkuber-tasty --ghci-options -fdiagnostics-color=always" --test "Main.main"
.PHONY: test
