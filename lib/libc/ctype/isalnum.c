#include <ctype.h>

int isalnum(int ch) {
  return isdigit(ch) || isalpha(ch);
}
