#include <sys/ioctl.h>
#include <stdio.h>

main()
{
  struct ttysize ts;
  ioctl(0, TIOCGSIZE, &ts);

  printf("lines:\t%d\n", ts.ts_lines);
  printf("columns:\t%d\n", ts.ts_cols);

  exit(0);
}
