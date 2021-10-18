import numpy as np
from colour import Color
from icecream import ic


def rgb2hex(c):
    return '%02x%02x%02x' % c


class ThemeGradients():
    BASE = 8

    def __init__(self, theme=(237, 166, 95), zero=(102, 102, 102)):
        """
        :param theme: theme color
        :param zero: default, base color
        """
        self.theme = np.array(theme)
        self.zero = np.array(zero)

    # def __call__(self, n=10, exclusive=True, exp='str', cnm='ThemeGradient'):
    #     """
    #     :param n: Number of distinct colors in between
    #     :param exclusive: If True, exclusive start, inclusive end, i.e. (base, theme]
    #     :param exp: Export type, array or string representation
    #         If `str`, returns LaTeX `xcolor` compatible colors
    #     :param cnm: Relevant to LaTeX export, the name defined for each gradient
    #     """
    #     # if exclusive:
    #     #     diff = (self.theme - self.zero) / n
    #     #     arr = list(map(lambda i: self.zero + (i+1) * diff, range(n)))
    #     # else:
    #     #     diff = (self.theme - self.zero) / (n-1)
    #     #     arr = list(map(lambda i: self.zero + (i) * diff, range(n)))
    #     # ic(diff, arr)

    #     if exp == 'str':
    #         s = ''
    #         for i in range(n):
    #             c = rgb2hex(tuple(arr[i].astype(int)))
    #             s += f'\\definecolor{{{cnm}{i+1 :02}}}{{HTML}}{{{c}}}'
    #             s += '\n'
    #         return s
    #     else:
    #         return arr

    def __call__(self, n=10):
        m = 2 ** self.BASE
        c_strt = Color(rgb=self.zero / m)
        c_end = Color(rgb=self.theme / m)

        def color2rgb(x):
            return list(map(lambda e: int(e * m), x.rgb))

        return list(map(color2rgb, c_strt.range_to(c_end, n)))


if __name__ == '__main__':
    # import os
    # os.chdir('..')

    tg = ThemeGradients()
    # print(tg(n=8, exclusive=False))
    cs = tg()
    ic(cs)
    # ic(cs[0])
