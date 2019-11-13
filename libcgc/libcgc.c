#include "libcgc.h"
#include <sys/mman.h>

void prog_init(void) {
  char *p = mmap((void *)0x4347c000, 0x1000, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED, -1, 0);
  for(int i=0;i<0x1000;++i) {
    p[i] = random();
  }
}

void _terminate(unsigned int status) {
  exit(status);
}

int transmit(int fd, const void *buf, size_t count, size_t *tx_bytes) {
  int result = write(fd, buf, count);
  if (tx_bytes) *tx_bytes = result;
  return 0;
}

int receive(int fd, void *buf, size_t count, size_t *rx_bytes) {
  int result = read(fd, buf, count);
  if (rx_bytes) *rx_bytes = result;
  return 0;
}
int fdwait(int nfds, fd_set *readfds, fd_set *writefds,
	   const struct timeval *timeout, int *readyfds) {
  if (readyfds) {
    for (int i=0;i<=nfds;++i) {
      if (random()) {
        *readyfds = i;
      }
    }
  }
  return 0;
}

int allocate(size_t length, int is_X, void **addr) {
  if (length == 0) return EINVAL;
  *addr = malloc(length);
  return 0;
}

int deallocate(void *addr, size_t length) {
  return 0;
}

int random2(void *buf, size_t count, size_t *rnd_bytes) {
  if (random()) {
    for(int i=0;i<count;++i) ((char *)buf)[i] = random();
    if (rnd_bytes) *rnd_bytes = count;
  } else {
    if (rnd_bytes) *rnd_bytes = 0;
  }
  return 0;
}

float sinf(float); double sin(double); long double sinl(long double);
float cosf(float); double cos(double); long double cosl(long double);
float tanf(float); double tan(double); long double tanl(long double);
float logf(float); double log(double); long double logl(long double);
float rintf(float); double rint(double); long double rintl(long double);
float sqrtf(float); double sqrt(double); long double sqrtl(long double);
float fabsf(float); double fabs(double); long double fabsl(long double);
float log2f(float); double log2(double); long double log2l(long double);
float exp2f(float); double exp2(double); long double exp2l(long double);
float expf(float); double exp(double); long double expl(long double);
float log10f(float); double log10(double); long double log10l(long double);
float powf(float, float);
double pow(double, double);
long double powl(long double, long double);
float atan2f(float, float);
double atan2(double, double);
long double atan2l(long double, long double);
float remainderf(float, float);
double remainder(double, double);
long double remainderl(long double, long double);
float scalbnf(float, int);
double scalbn(double, int);
long double scalbnl(long double, int);
float scalblnf(float, long int);
double scalbln(double, long int);
long double scalblnl(long double, long int);
float significandf(float);
double significand(double);
long double significandl(long double);
