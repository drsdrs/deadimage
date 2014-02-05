this.onmessage = function(event) {
  var L, c, d, ed, formSum, formula, h, l, makeSampleFunction, p, w, x, y, z;
  ed = event.data;
  p = ed.p;
  L = ed.L;
  w = ed.w;
  h = ed.h;
  z = 4;
  formula = ed.formula;
  makeSampleFunction = function(formula) {
    return new Function("x, y, c, l, d, p, L, w, h", "return " + formula);
  };
  formSum = makeSampleFunction(formula);
  l = 0;
  y = 0;
  while (y < h) {
    x = 0;
    while (x < w) {
      c = 0;
      while (c < z) {
        d = p[l];
        p[l] = formSum(x, y, c, l, d, p, L, w, h);
        c++;
        l++;
      }
      x++;
    }
    y++;
  }
  return postMessage(p);
};