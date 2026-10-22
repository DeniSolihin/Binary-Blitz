class BinaryUtils {
  // Mengonversi angka desimal ke string biner (contoh: 5 dengan bitLength 5 -> "00101")
  static String decimalToBinary(int value, int bitLength) {
    return value.toRadixString(2).padLeft(bitLength, '0');
  }

  // Mengonversi array bit (contoh: [1, 0, 1, 0]) ke nilai desimal
  static int binaryBitsToDecimal(List<int> bits) {
    int decimal = 0;
    for (int i = 0; i < bits.length; i++) {
      int power = bits.length - 1 - i;
      decimal += bits[i] * (1 << power);
    }
    return decimal;
  }

  // Mengonversi String Hexadesimal ke string biner 8-bit (contoh: "3F" -> "00111111")
  static String hexToBinary(String hex) {
    int decimal = int.parse(hex, radix: 16);
    return decimalToBinary(decimal, 8);
  }
}