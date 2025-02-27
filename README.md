# README: Kompilacja i Debugowanie MSP430 w VSC i MSPDebug

## 1️⃣ Tworzenie i Kompilacja kodu asemblerowego
1. Utwórz plik `main.s` w katalogu projektu.
2. Napisz kod asemblerowy:
   ```assembly
   .global _start
   .text

   _start:
       mov #0x2400, SP   ; Ustaw stos
       mov #0x40, R4     ; Wpisz wartość do R4
       nop               ; Zatrzymaj program
   ```
3. Skompiluj kod:
   ```sh
   msp430-elf-as -o main.o main.s
   ```
4. Linkowanie:
   ```sh
   msp430-elf-ld -o main.elf main.o
   ```
5. Opcjonalna konwersja do `.hex`:
   ```sh
   msp430-elf-objcopy -O ihex main.elf main.hex
   ```

---

## 2️⃣ Wgrywanie programu na płytkę MSP430
1. Podłącz płytkę do komputera.
2. Uruchom `mspdebug`:
   ```sh
   mspdebug rf2500
   ```
   *(dla LaunchPad: `mspdebug tilib`)*
3. Wgraj program:
   ```sh
   load main.elf
   ```
4. Uruchom program:
   ```sh
   run
   ```

---

## 3️⃣ Debugowanie w MSPDebug
1. Ustawienie breakpointa:
   ```sh
   break _start
   ```
2. Wykonanie jednej instrukcji:
   ```sh
   step
   ```
3. Kontynuacja programu:
   ```sh
   continue
   ```
4. Podgląd rejestrów:
   ```sh
   regs
   ```
5. Podgląd pamięci:
   ```sh
   md 0x2000 16
   ```

---

## 4️⃣ Debugowanie w Visual Studio Code
1. Upewnij się, że masz plik `launch.json` w `.vscode/`.
2. Uruchom `mspdebug` w trybie GDB:
   ```sh
   mspdebug rf2500 gdb
   ```
   *(dla LaunchPad: `mspdebug tilib gdb`)*
3. W VSC wybierz **"Run and Debug"** → **"Debug MSP430"**.
4. Możesz ustawiać breakpointy i debugować program krok po kroku.

---

# Uruchamianie programu na komputerze (Linux x86)

## Kompilacja i uruchomienie main.s w systemie Linux (x86)
1. Zmontuj kod:
   ```sh
   nasm -f elf32 main.s -o main.o
   ```
2. Połącz obiekt do pliku wykonywalnego:
   ```sh
   ld -m elf_i386 main.o -o main
   ```
3. Uruchom program:
   ```sh
   ./main
   ```

---

# Uruchamianie programu na komputerze (macOS x86)

## Kompilacja i uruchomienie main.s w systemie macOS (x86)
1. Zainstaluj `nasm` (jeśli jeszcze go nie masz):
   ```sh
   brew install nasm
   ```
2. Zmontuj kod:
   ```sh
   nasm -f macho32 main.s -o main.o
   ```
3. Połącz obiekt do pliku wykonywalnego:
   ```sh
   ld -e _start -o main main.o -arch i386 -macos_version_min 10.7 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/libSystem.dylib
   ```
4. Uruchom program:
   ```sh
   ./main
   ```

---

# Wyjaśnienie podstaw składni i operacji w Assembly

## Podstawy składni

- Instrukcje mogą być poprzedzone etykietą.
- Użycie rejestrów (np. EAX, EBX, ECX, EDX) oraz wartości natychmiastowych (prefiks $).
- Komentarze zaczynają się od średnika (;) lub //.
- Dyrektywy (.global, .text, .data) definiują segmenty kodu.

## Podstawowe operacje

- mov: Przenosi dane między rejestrami lub z pamięci.
- cmp: Porównanie wartości.
- jmp, je: Skoki warunkowe i bezwarunkowe.

## ✅ Podsumowanie
- **Kompilacja (MSP430):** `msp430-elf-as` → `msp430-elf-ld`
- **Wgrywanie (MSP430):** `mspdebug rf2500` → `load main.elf`
- **Debugowanie w terminalu (MSP430):** `mspdebug` (break, step, regs)
- **Debugowanie w VSC (MSP430):** `mspdebug gdb` + `"Run and Debug"`
- **Kompilacja (Linux x86):** `nasm -f elf32` → `ld -m elf_i386`
- **Uruchamianie (Linux x86):** `./main`
- **Kompilacja (macOS x86):** `nasm -f macho32` → `ld -e _start -arch i386 /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/libSystem.dylib`
- **Uruchamianie (macOS x86):** `./main`

Upewnij się, że używasz odpowiednich narzędzi dla MSP430 (`msp430-elf-as`, `msp430-elf-ld`, `mspdebug`) oraz narzędzi `nasm` i `ld` na swoim systemie Linux lub macOS. Jeśli masz jakiekolwiek pytania lub problemy, daj znać!
