public abstract class AssemblerInstruction {
  @SuppressWarnings("deprecation") //added by steven miller on 8/27/2024
  public static final int DATA_INSTRUCTION = 0;
  public static final int OPCODE_INSTRUCTION = 1;

  public abstract int getInstructionType();
  public abstract short getAddr();
  public abstract int getLineNum();
}
