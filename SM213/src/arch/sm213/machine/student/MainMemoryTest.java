package arch.sm213.machine.student;
import machine.AbstractMainMemory;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;
import java.util.Arrays;

public class MainMemoryTest {
    MainMemory mem;
    MainMemory mem1;
    @Before
    public void initialize() {
        mem = new MainMemory(20000);
        mem1 = new MainMemory(0);
    }

    @Test
    public void TestisAccessAligned() {
        assertTrue(mem.isAccessAligned(0,4)); // 0 mod 4 = 0; 4 bytes would go into 0-3 memory block
        assertTrue(mem.isAccessAligned(4,4)); // 4 mod 4 = 0; 4 bytes would go into 4-7 memory block
        assertFalse(mem.isAccessAligned(2,4)); // 2 mod 4 = 2; 4 bytes would extend into two memory blocks
        assertTrue(mem.isAccessAligned(4,1)); // 1 byte only goes into one block
        assertTrue(mem.isAccessAligned(8,2)); // 8 mod 2 = 0, testing different address
        assertFalse(mem.isAccessAligned(8,3)); // 8 mod 3 = 2; would extend into another memory block
        assertFalse(mem.isAccessAligned(4,3)); // 4 mod 3 = 1; would extend into another memory block
        assertTrue(mem.isAccessAligned(9,3)); // 9 mod 3 = 0
    }

    @Test
    public void TestbytesToInteger() {
        assertEquals(0, mem.bytesToInteger((byte) 0x00, (byte)0x00,(byte) 0x00,(byte) 0x00)); // test for zero
        assertEquals(268435472, mem.bytesToInteger((byte)0x10, (byte)0x00, (byte)0x00, (byte)0x10)); // a positive value
        assertEquals(-16711169, mem.bytesToInteger((byte)0xff, (byte)0x01, (byte)0x01, (byte)0xff)); // a negative value
        assertEquals(-1, mem.bytesToInteger((byte)0xff, (byte)0xff, (byte)0xff, (byte)0xff)); // negative 1
        assertEquals(Integer.MAX_VALUE, mem.bytesToInteger((byte) 0x7f,(byte)0xff,(byte)0xff,(byte)0xff)); // largest
        assertEquals(Integer.MIN_VALUE, mem.bytesToInteger((byte) 0x80,(byte) 0x00,(byte) 0x00,(byte) 0x00)); // smallest val
    }

    @Test
    public void TestintegerToBytes () {
        byte[] b1 = {(byte)0x00,(byte)0x00,(byte)0x00,(byte)0x00};
        byte[] b2 = { 0x10,0x00,0x00,0x10 };
        byte[] b3 = { (byte)0xff,0x01,0x01,(byte)0xff};
        byte[] b4 = { (byte)0xff, (byte) 0xff, (byte)0xff, (byte)0xff};
        byte[] b5 = { 0x7f,(byte)0xff,(byte)0xff,(byte)0xff};
        byte[] b6 = { (byte)0x80,0x00,0x00,0x00};

        assertEquals(Arrays.toString(b1), Arrays.toString(mem.integerToBytes(0))); // testing 0
        assertEquals(Arrays.toString(b2), Arrays.toString(mem.integerToBytes(268435472))); // testing positive int
        assertEquals(Arrays.toString(b3), Arrays.toString(mem.integerToBytes(-16711169))); // testing NEGATIVE int
        assertEquals(Arrays.toString(b4), Arrays.toString(mem.integerToBytes(-1))); // testing NEGATIVE 1
        assertEquals(Arrays.toString(b5), Arrays.toString(mem.integerToBytes(Integer.MAX_VALUE))); // testing MAX POS VAL
        assertEquals(Arrays.toString(b6), Arrays.toString(mem.integerToBytes(Integer.MIN_VALUE))); // testing MAX POS VAL
    }

    @Test

    public void Testgetset() throws AbstractMainMemory.InvalidAddressException {
        byte[] seq1 = {};
        byte[] seq2 = {1,2,3};
        byte[] seq3 = {1,2,3,4,5,6,7};

        // Testing Set failed cases
         // case1 address < 0; seq.length + address > mem1.length (this is ok), should throw an error
        try{
            mem1.set(-1,seq1);
            fail();
        } catch (AbstractMainMemory.InvalidAddressException e) {
            System.out.println("address must be > 0");
        }
        // case 2 address is > 0; but seq.length > mem.length
        MainMemory mem2 = new MainMemory(2);
        try {
            mem2.set(1,seq2);
            fail();
        } catch (AbstractMainMemory.InvalidAddressException e) {
            System.out.println("value length + address exceeds memory");
        }
        // Testing Get failed cases
        // case1 address < 0; length + address > mem1.length (this is ok), should throw an error
        try {
            mem1.get(-1,0);
        } catch (AbstractMainMemory.InvalidAddressException e) {
            System.out.println("address must be => 0");
        }
        // case2 address >  0; length + address > mem, should throw an error
        try {
            mem.get(1,mem.length()+1);
        } catch (AbstractMainMemory.InvalidAddressException e) {
            System.out.println("No more things to be fetched!");
        }

        // Testing successful set and get cases
        // case 1: set 00, get 00
        mem1.set(0,seq1);
        assertEquals(Arrays.toString(mem1.get(0,0)), Arrays.toString(seq1));

        //case 2: test from address 0 to the end on seq 2
        mem.set(0,seq2);
        assertEquals(Arrays.toString(mem.get(0,seq2.length)), Arrays.toString(seq2));

        //case 3: test from address 1 to 2nd end of seq3
        mem.set(1,seq3);
        assertEquals(Arrays.toString(mem.get(1,seq3.length)), Arrays.toString(seq3));

        //case 4: end case of setting and getting the last byte in mem3 address
        MainMemory mem3 = new MainMemory(4);
        byte[] seq4 = {0x0A};
        mem3.set(3,seq4);
        assertEquals(Arrays.toString(seq4),Arrays.toString(mem3.get(3,seq4.length)));
    }

}
