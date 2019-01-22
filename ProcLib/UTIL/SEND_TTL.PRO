
#include C:/TEMPO/ProcLib/UTIL/WAIT_MU.PRO

declare SEND_TTL(int value);

process SEND_TTL(int value)
{
  declare int output = 1;

  // set ports A, B, and C to send strobes (output)
  dioSetMode(output, PORTA|PORTB|PORTC);
  // load the low 8 bits on port A
  dioSetA(output, value & 0xFF);
  // load the high 8 bits on port B
  dioSetB(output, (value >> 8) | 0x80);
// wait 100 micro seconds to avoid losing events
  spawnwait WAIT_MU(200);

  dioSetA(output, ~0xFF);
  dioSetB(output, ~0xFF);
}
