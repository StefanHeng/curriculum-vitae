import numpy as np
from colour import Color
from icecream import ic


def rgb2hex(c):
    return '%02x%02x%02x' % c


def hex2rgb(h):
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))


def mix(c1, c2, r=0.5):
    """
    Mixes two colors
    """
    def _mix(m1, m2):
        return m1 * r + m2 * (1-r)

    return tuple(map(lambda x: int(_mix(*x)), zip(c1, c2)))


class ThemeGradients():
    BASE = 8

    def __init__(self, theme=(237, 166, 95), zero=(102, 102, 102)):
        """
        :param theme: theme color
        :param zero: default, base color
        """
        self.theme = np.array(theme)
        self.zero = np.array(zero)

    def __call__(self, n=10, exclusive=True, exp='str', cnm='ThemeGradient'):
        """
        :param n: Number of distinct colors in between
        :param exclusive: If True, exclusive start, inclusive end, i.e. (base, theme]
        :param exp: Export type, array or string representation
            If `str`, returns LaTeX `xcolor` compatible colors
        :param cnm: Relevant to LaTeX export, the name defined for each gradient
        """
        def _get(n_):
            m = 2 ** self.BASE
            c_strt = Color(rgb=self.zero / m)
            c_end = Color(rgb=self.theme / m)

            def color2rgb(x):
                return list(map(lambda e: int(e * m), x.rgb))

            return list(map(color2rgb, c_strt.range_to(c_end, n_)))

        arr = _get(n+1)[:-1] if exclusive else _get(n)
        # ic(arr)

        if exp == 'str':
            s = ''
            for i in range(n):
                c = rgb2hex(tuple(arr[i]))
                s += f'\\definecolor{{{cnm}{i+1 :02}}}{{HTML}}{{{c}}}'
                s += '\n'
            return s
        else:
            return arr


if __name__ == '__main__':
    # import os
    # os.chdir('..')

    def _gradients():
        tg = ThemeGradients()
        print(tg(n=8, exclusive=False))
        # cs = tg()
        # ic(cs)
        # ic(cs[0])

    def _my_mix():
        slateGrey = hex2rgb('2E2E2E')
        lightGrey = hex2rgb('666666')
        m = mix(slateGrey, lightGrey, r=0.2)
        ic(m)
        ic(rgb2hex(m))

    _my_mix()

