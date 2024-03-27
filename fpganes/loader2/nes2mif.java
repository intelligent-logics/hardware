// binary dump of a file: xxd -b -c 1 S$INFILE| cut -d" " -f 2 > $OUTFILE

import java.io.*;

public class nes2mif {

  public static void main(String[] args) {

    if (args.length != 3) {
      System.err.println("Incorrect arguements\nPlease use: \"java nes2mif"
                         + " <infile> <outfile1> <outfile2>\"");
      System.exit(-1);
    }

    String inPath, progOutPath, charOutPath;
    inPath = args[0];
    progOutPath = args[1];
    charOutPath = args[2];

    try {
      File infile = new File(inPath);
      File progOutfile = new File(progOutPath);
      File charOutfile = new File(charOutPath);

      byte[] bytes = new byte[(int) infile.length()];
      InputStream bytesIn = new BufferedInputStream(new FileInputStream(infile));

      PrintWriter progRomPrinter = new PrintWriter(progOutfile);
      PrintWriter charRomPrinter = new PrintWriter(charOutfile);

      try {
        bytesIn.read(bytes, 0, (int) infile.length());
        bytesIn.close();
      }
      catch (IOException ioe) {
        System.out.println("IOException when reading bytes");
        System.exit(-1);
      }

      int progRomLength; // the ending byte of the character rom
      int charRomStart;
      int charRomLength;

      // determine prog and char rom size
      progRomLength = 32768; // currently only support mmc0
      charRomLength = 8192;

      // print mif headers to the output files
      progRomPrinter.println("DEPTH = 32768;\nWIDTH = 16;\nADDRESS_RADIX = HEX;"
                              + "\nDATA_RADIX = BIN;\nCONTENT\nBEGIN\n");
      charRomPrinter.println("DEPTH = 8192;\nWIDTH = 16;\nADDRESS_RADIX = HEX;"
                              + "\nDATA_RADIX = BIN;\nCONTENT\nBEGIN\n");

      // loop over all bytes and print them to correct rom file
      for (int address = 0; address < progRomLength / 2; address++) {
        // write prog rom file
        progRomPrinter.print(String.format("%6X", (address)).replace(" ", "0"));
        progRomPrinter.print(" : ");
        progRomPrinter.print(String.format("%8s", Integer.toBinaryString(((int) bytes[address * 2 + 16]) & 0xFF)).replace(' ', '0'));
        progRomPrinter.println(String.format("%8s;", Integer.toBinaryString(((int) bytes[address * 2 + 17]) & 0xFF)).replace(' ', '0'));
      }

      for (int address = 0; address < charRomLength / 2; address++) {
        charRomPrinter.print(String.format("%6X", (address)).replace(" ", "0"));
        charRomPrinter.print(" : ");
        charRomPrinter.print(String.format("%8s", Integer.toBinaryString(((int) bytes[(address * 2 + progRomLength + 16)] & 0xFF))).replace(' ', '0'));
        charRomPrinter.println(String.format("%8s;", Integer.toBinaryString(((int) bytes[(address * 2 + progRomLength + 17)] & 0xFF))).replace(' ', '0'));
      }

	  progRomPrinter.print("END;");
    charRomPrinter.print("END;");

      progRomPrinter.close();
      charRomPrinter.close();

    }
    catch (FileNotFoundException fnfe) {
      System.err.println("File paths incorrect");
      System.exit(-1);
    }
  }
}
