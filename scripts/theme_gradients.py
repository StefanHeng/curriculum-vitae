import numpy as np
from icecream import ic


def rgb2hex(c):
    return '%02x%02x%02x' % c


class ThemeGradients():
    def __init__(self, theme=(237, 166, 95), zero=(102, 102, 102)):
        """
        :param theme: theme color
        :param zero: default, base color
        """
        self.theme = np.array(theme)
        self.zero = np.array(zero)

    def __call__(self, n=10, exp='str', cnm='ThemeGradient'):
        """
        :param n: Number of distinct colors in between, exclusive start, inclusive end,
        i.e. (base, theme]
        :param exp: Export type, array or string representation
            If `str`, returns LaTeX `xcolor` compatible colors
        :param cnm: Relevant to LaTeX export, the name defined for each gradient
        """

        diff = (self.theme - self.zero) / n
        ic(diff)
        arr = list(map(lambda i: self.zero + (i+1) * diff, range(n)))
        ic(arr)

        if exp == 'str':
            s = ''
            for i in range(n):
                c = rgb2hex(tuple(arr[i].astype(int)))
                s += f'\\definecolor{{{cnm}{i+1 :02}}}{{HTML}}{{{c}}}'
                s += '\n'
            return s
        else:
            return arr


if __name__ == '__main__':
    # import os
    # os.chdir('..')

    tg = ThemeGradients()
    print(tg())
