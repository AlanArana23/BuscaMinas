/*Busca Minas
 *Author: Alan Arana
 * Date: 13/03/2024
 * Description: The lines of code for build a "Buscaminas"
 * BuscaMinas.swift
 * -2 -> places untouched
 * -1 -> Mine
 * 0 -> 0 mines near
 * 1 -> 1 mine near
 * 2 -> 2 mines near
 * 3 -> 3 mines near
 * 4 -> 4 mines near
 * 5 -> 5 mines near
 */
import Foundation

// Size of the board
let size : Int = 5;

// Build the board
var board = Array(repeating: Array(repeating: -2, count: size), count: size);

// Gaming stats
var isGaming = true;

// To Show the head of the board
// in -> void
// out -> head board
func printHeadBoard() {
    print("#️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣", terminator: "");
    print();
}

// To Show the row of the board
// in -> index : Int
// out -> head board
func printRowBoard(_ index: Int) {
    if (index == 0) { print("1️⃣ ", terminator: ""); }
    else if (index == 1) { print("2️⃣ ", terminator: ""); }
    else if (index == 2) { print("3️⃣ ", terminator: ""); }
    else if (index == 3) { print("4️⃣ ", terminator: ""); }
    else if (index == 4) { print("5️⃣ ", terminator: ""); }
}

// To Show the board
// in -> void
// out -> board
func printBoard() {
    printHeadBoard();

    for (index , row) in board.enumerated() {
        printRowBoard(index);
        for cell in row {
            if (cell == -2) { print("⬜", terminator: ""); }
            else if (cell == -1 && isGaming) { print("⬜", terminator: ""); }
            else if (cell == -1) { print("💣", terminator: ""); }
            else if (cell == 0) { print("🔳", terminator: ""); }
            else if (cell == 1) { print(" 1", terminator: ""); }
            else if (cell == 2) { print(" 2", terminator: ""); }
            else if (cell == 3) { print(" 3", terminator: ""); }
            else if (cell == 4) { print(" 4", terminator: ""); }
            else if (cell == 5) { print(" 5", terminator: ""); }
        }
        print()
    }
}

// To set mines in the board
// in -> size : Int 
// out -> void
func setMines(_ size: Int) {
    var minesCount = 0;
    while minesCount < size {
        let row = Int.random(in: 0..<size);
        let col = Int.random(in: 0..<size);
        
        if (board[row][col]) == -2 {
            board[row][col] = -1;
            minesCount += 1;
        }
    }
}

// To clean the terminal
// in -> void
// out -> void
func cleanTerminal() {
    print(String(repeating: "\n", count: 100))
}

// To check if a positon has boom near
// in -> row : Int col : Int
// out -> minesNear : Int
func checkPosition(_ row: Int,_ col: Int) -> Int {
    // Define los rangos para las filas y columnas adyacentes
    let rowRange = max(row - 1, 0)...min(row + 1, size - 1)
    let colRange = max(col - 1, 0)...min(col + 1, size - 1)

    // Inicia el contador de minas
    var minesCount = 0

    // Itera sobre las celdas adyacentes
    for i in rowRange {
        for j in colRange {
            // Asegúrate de no contar la celda central
            if i == row && j == col {
                continue
            }
            // Incrementa el contador si hay una mina
            if board[i][j] == -1 {
                minesCount += 1
            }
        }
    }

    return minesCount
}

// To move if a checkPosition == 0
// in -> row : Int col : Int
// out -> void
func revealAdjacentCells(_ row: Int, _ col: Int) {
    let rowRange = max(row - 1, 0)...min(row + 1, size - 1)
    let colRange = max(col - 1, 0)...min(col + 1, size - 1)

    for i in rowRange {
        for j in colRange {
            // Evita revisar la celda fuera del rango o ya revelada
            if i >= 0 && i < size && j >= 0 && j < size && board[i][j] == -2 {
                let minesCount = checkPosition(i, j)
                board[i][j] = minesCount
                
                // Si no hay minas adyacentes, sigue revelando recursivamente
                if minesCount == 0 {
                    revealAdjacentCells(i, j)
                }
            }
        }
    }
}

func checkVictory() -> Bool {
    for row in board {
        for col in row {
            if (col == -2) {
                return false;
            }
        }
    }
    return true;
}

//start the game
cleanTerminal();
print("💣 BUSCAMINAS 💣");
setMines(size);
while isGaming {
    printBoard();

    // Print message
    var message = "Ingrese las coordenadas(filas de 1-5 y columnas del 1-5 , separadas por un espacio)";
    message = message + " ~~o 's' para terminar: "
    print( message, terminator: "")

    let input = readLine()!;
    if input == "s" { break; }


    let coords = input.split(separator: " ")
    if coords.count == 2 {
        let row = (Int(String(coords[0])) ?? 0) - 1;
        let col = (Int(String(coords[1])) ?? 0) - 1;

        if row >= 0 && row < size && col >= 0 && col < size {
            if board[row][col] == -2 {
                let minesAround = checkPosition(row, col)
                if minesAround == 0 {
                    revealAdjacentCells(row, col) // Llama a la nueva función para expandir desde aquí
                } else {
                    board[row][col] = minesAround // Simplemente revela el número de minas cercanas
                }
            } else if board[row][col] == -1 {
                isGaming = false;
                cleanTerminal();
                print("🤡 Perdiste 😂.");
                printBoard()
            }
            if checkVictory(){
                isGaming = false;
                cleanTerminal();
                print("🏆 Ganaste 🥇.");
                printBoard()
            }
        } else {
            print("Coordenadas inválidas, intenta de nuevo.")
        }
    } 
    if isGaming { cleanTerminal(); }
}
