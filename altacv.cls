%%%%%%%%%%%%%%%%%
% This is altacv.cls (v1.7.3, 31 Oct 2024) written by
% LianTze Lim (liantze@gmail.com).
%
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.
%%
%%
% Contributions:
% - https://github.com/akreuzer Added ragged2e option (5 Nov 2018)
% - https://github.com/stefanogermano Fixed bad boxes and undefined font shape (July 2018)
% - https://github.com/foohyfooh Fixed blank spaces in \cvevent and bad link in README.md (June 2018)
% - https://github.com/logological Remove redundant hyperref and typos (Apr 2021)

%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{altacv}[2024/10/31 AltaCV v1.7.3, yet another alternative class for a resume/curriculum vitae.]

%% v1.1: Optionally load academicons
%% v1.4: Nope, academicons is unnecessary; fontawesome5 has \faOrcid.
%% v1.7.3: Re backward compatibility we'll now load academicons automatically for \aiOrcid if ≤TL2019 i.e. if \faOrcid undefined
\DeclareOption{academicons}{\ClassWarning{altacv}{academicons option is now obsolete and unnecessary.}}
%% v1.1.3: Choice of round/square photo
\newif\if@normalphoto
\DeclareOption{normalphoto}{\@normalphototrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
%% v1.3: load hyperref for clickable hyperlinks
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
\ProcessOptions\relax

\LoadClass{extarticle}
\RequirePackage{etoolbox}
% v1.7.3 Load xcolor early to avoid receiving `hyperref` option from pdfx package
\RequirePackage{xcolor}
%% v1.3.2 Hopefully this helps make the PDF
%% file more 'friendly' with copy-paste etc
% ====================================== Begin of Modified ======================================
% \RequirePackage[a-1b]{pdfx}
\RequirePackage[a-2u]{pdfx}
% ====================================== End of Modified ======================================
\RequirePackage{accsupp}
%% v1.7.3 Avoid 'Token not allowed' when \\ used with accsupp
\pdfstringdefDisableCommands{
  \let\\\space
}
\RequirePackage{xparse}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}%[2020-01-15]

% 1.7.3 For backward compatibility
\providecommand\IfFormatAtLeastTF{\@ifl@t@r\fmtversion}
\IfFormatAtLeastTF{2021-11-15}{}{\RequirePackage{scrlfile}}

% v1.7.2 Add simpleicons to provide X icon
% v1.7.3 But first check if the package files exist
\IfFileExists{simpleiconsglyphs-pdftex.tex}{\RequirePackage{simpleicons}}{}

% v1.7.3 Use iftex for easier access to \iftutex
\RequirePackage{iftex}
% ...but still check for backward compatibility
\ifundef{\iftutex}{%
  \newif\iftutex
  \ifxetex\tutextrue
  \else
    \ifluatex\tutextrue\else\tutexfalse\fi
  \fi
}{}
\iftutex
  \RequirePackage{fontspec}
\else
  %% v1.3.2 attempts to make ligatures
  %% copy-paste as normal characters
  \RequirePackage{cmap}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \input{glyphtounicode}
  \pdfglyphtounicode{f_f}{FB00}
  \pdfglyphtounicode{f_f_i}{FB03}
  \pdfglyphtounicode{f_f_l}{FB04}
  \pdfglyphtounicode{f_i}{FB01}
  \pdfgentounicode=1
\fi

\if@raggedtwoe
  \RequirePackage[newcommands]{ragged2e}
\fi

% 1.7.3 For backward compatibility re hooks management
\if@withhyper
\IfFormatAtLeastTF{2020-10-01}{%
  \AddToHook{begindocument/before}{\hypersetup{hidelinks}\urlstyle{same}}
}{%
  \AtBeginDocument{\hypersetup{hidelinks}\urlstyle{same}}
}
\fi

\colorlet{accent}{blue!70!black}
\colorlet{emphasis}{black}
\colorlet{heading}{black}
\colorlet{headingrule}{black}
\colorlet{subheading}{emphasis}
\colorlet{body}{black!80!white}
\colorlet{name}{heading}
\colorlet{tagline}{accent}
% Renamed or added v1.7
\newcommand{\cvItemMarker}{{\small\textbullet}}
\newcommand{\cvRatingMarker}{\faCircle}
\let\itemmarker\cvItemMarker      % for backward compatibility
\let\ratingmarker\cvRatingMarker  % for backward compatibility
\newcommand{\cvDateMarker}{\faCalendar[regular]}
\newcommand{\cvLocationMarker}{\faMapMarker}
\newcommand{\locationname}{Location}
\newcommand{\datename}{Date}

% ====================================== Begin of Added ======================================
\colorlet{link}{accent}
\colorlet{achievement}{emphasis}
\colorlet{affiliation}{emphasis}

\RequirePackage{etoolbox}
\newtoggle{inAccSupp}
\togglefalse{inAccSupp}

\newcommand{\myBeginAccSupp}[1]{%
  \iftoggle{inAccSupp}{}{%
    \toggletrue{inAccSupp}%
  }%
  \BeginAccSupp{#1}%
}
\newcommand{\myEndAccSupp}{%
  \EndAccSupp{}%
  \iftoggle{inAccSupp}{\togglefalse{inAccSupp}}{}%
}

\NewDocumentCommand{\IconTxt}{ m m }{% Icon ActualText override (per use)
  \myBeginAccSupp{method=escape,ActualText={#2}}#1\myEndAccSupp{}%
}

% clear out icons from ATS parsing
% \newcommand{\hidefromextract}[1]{\BeginAccSupp{ActualText={}}#1\EndAccSupp{}}
\newcommand{\hideFromExtract}[1]{\myBeginAccSupp{ActualText={}}#1\myEndAccSupp{}}


% Pretty underline, inspired by https://tex.stackexchange.com/a/518546
% \RequirePackage{ulem}
% \normalem
% \RequirePackage{contour}
% \renewcommand{\ULdepth}{1.8pt}
% \contourlength{0.8pt}
% \newcommand{\ul}[1]{\uline{\phantom{#1}}\llap{\contour{white}{#1}}}
% \newcommand{\ul}[1]{%
  % \BeginAccSupp{method=escape,ActualText={#1}}%
    % \uline{\phantom{#1}}\llap{\contour{white}{#1}}%
  % \EndAccSupp{}%
% }
% \newcommand{\ul}[1]{%
%   \iftoggle{inAccSupp}{%
%     % Already in an outer AccSupp—don’t add another one.
%     \uline{\phantom{#1}}\llap{\contour{white}{#1}}%
%   }{%
%     % Not inside an AccSupp: wrap with one.
%     \BeginAccSupp{method=escape,ActualText={#1}}%
%       \uline{\phantom{#1}}\llap{\contour{white}{#1}}%
%     \EndAccSupp{}%
%   }%
% }

% % ---- ATS-safe pretty underline (LuaLaTeX) ----
\RequirePackage{ulem}
\normalem
% \RequirePackage{contour}
% \RequirePackage{accsupp}
% \RequirePackage{pdfrender}

% \renewcommand{\ULdepth}{1.8pt}
\renewcommand{\ULdepth}{2.2pt}
% \contourlength{0.8pt}

% \newcommand{\ul}[1]{%
%   \BeginAccSupp{ActualText={}}%
%     \uline{\phantom{#1}}%
%   \EndAccSupp{}
%   \llap{%
%     \BeginAccSupp{method=escape,ActualText={#1}}%
%       {\pdfrender{TextRenderingMode=3}#1}%
%     \EndAccSupp{}
%   }%
%   \llap{%
%     \BeginAccSupp{ActualText={}}%
%       \contour{white}{#1}%
%     \EndAccSupp{}
%   }%
% }
% nice contour for escaping descender underlines will unfortunately cause repetition in PDF Miner parsing
\newcommand{\ul}[1]{\uline{#1}}


% ====================================== End of Added ======================================

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\cvItemMarker}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}
% ====================================== End of Added ======================================
% \newcommand{\dividerSmall}{
%     \vspace{-0.5ex}
%     \noindent\smash{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\smallskip}
% }
\newcommand{\dividerSmall}{%
%   % \vspace{-0.75ex}%
%   \bodyfontsize
%   \vspace{-1ex}%
%   \noindent\raisebox{0.5ex}{%
%     \textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}%
%   }%
% %   \vspace{-0.75ex}%
%   \vspace{-0.5ex}%
  \par
  \begingroup\skip0=\lastskip \vspace*{-\skip0}\endgroup
  \nointerlineskip
  % \textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}%
  \noindent\raisebox{-0.5ex}{%
    \textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}%
  }%
  \par\vspace{0.25ex}%
}
% ====================================== End of Added ======================================

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}

%% v1.3.1 \detokenize will break UTF-8 in pdflatex
%% Using alternative from https://tex.stackexchange.com/a/530911/226
\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
  \catcode`\_=12%
%   \catcode`\^=12%
%   \catcode`\{=12%
%   \catcode`\}=12%
  \catcode`\&=12%
  \catcode`\$=12%
  \catcode`\#=12%
  \catcode`\~=12%
%   \catcode`\\=12%
  {#1}%
}%
}
%% v1.3: Incorporating hyperlinks
%% v1.3.1: using \utffriendlydetokenize to avoid breaking unicode
%% v1.6: Use accsupp so that when copying/pasting the icon from PDF to a text
%%       file, the icon name is pasted
%% v1.7: Some tweaks/corrections so that accsupp is for icons only
%% v1.7.1: Bugfix to support some symbol commands e.g. academicons commands
\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
  \IfNoValueTF{#3}{%
    % ====================================== Begin of Modified ======================================
    % \mbox{\textcolor{accent}%
    % {\BeginAccSupp{method=escape,ActualText={\detokenize{#1}:}}\normalfont #1\EndAccSupp{}}%
    % ~\utffriendlydetokenize{#2}\hspace{2em}}%
    \mbox{%  include both within AccSupp to add a newline
        \myBeginAccSupp{method=escape,ActualText={\detokenize{- #1: #2^^J}}}%
            \textcolor{accent}{\normalfont #1}
            ~\utffriendlydetokenize{#2}\hspace{2em}%
        \myEndAccSupp{}%
    }%
    % ====================================== End of Modified ======================================
  }{%
     \if@withhyper%
        % ====================================== Begin of Modified ======================================
    %   \mbox{\textcolor{accent}%
    %   {\BeginAccSupp{method=escape,ActualText={\detokenize{#1}:}}\normalfont #1\EndAccSupp{}}%
    %   ~\href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
        \myBeginAccSupp{method=escape,ActualText={\detokenize{- #1: #2 (#3)^^J}}}% include both parts as a single ActualText; add newline to separate
            \mbox{%
                \textcolor{accent}{\normalfont #1}%
                ~\href{#3}{\utffriendlydetokenize{\ul{\textcolor{emphasis}{#2}}}}\hspace{2em}% use `emphasis`' color & underline instead
            }%
        \myEndAccSupp{}%
        % ====================================== End of Modified ======================================
     \else%
       \ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
      \mbox{\textcolor{accent}
      {\BeginAccSupp{method=escape,ActualText={\detokenize{#1}:}}\normalfont #1\EndAccSupp{}}%
      ~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
     \fi%
  }%
}%

% ====================================== Begin of Added ======================================
\NewDocumentCommand{\printinfoLabeled}{m m m o}{%
  \IfNoValueTF{#4}{%
    \mbox{%
      \myBeginAccSupp{method=escape,ActualText={- #1: ~#3^^J}}%
        \textcolor{accent}{\normalfont #2}~\utffriendlydetokenize{#3}\hspace{2em}%
      \myEndAccSupp{}%
    }%
  }{%
    \myBeginAccSupp{method=escape,ActualText={- #1: ~#3 (#4)^^J}}%
      \mbox{%
        \textcolor{accent}{\normalfont #2}~%
        \href{#4}{\utffriendlydetokenize{\ul{\textcolor{link}{#3}}}}\hspace{2em}%
        % \href{#4}{\utffriendlydetokenize{\textcolor{link}{#3}}}\hspace{2em}%
      }%
    \myEndAccSupp{}%
  }%
}
% ====================================== End of Added ======================================



%% v1.3: Exploring convenient creation of fields
%% v1.6: Add starred mode to create \printinfo with full URL
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanF{#1}{
    \IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
  }
  \csdef{#2 symbol}{#3}
  \IfBooleanTF{#1}
    { \csdef{#2}##1##2{%
        \if@withhyper
          \IfNoValueTF {##2}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[##2]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
    { \csdef{#2}##1{%
        \if@withhyper
          \IfNoValueTF {#4}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
}
\ExplSyntaxOff

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{\faAt}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{phone}{\faPhone}[tel:]
\NewInfoField{homepage}{\faGlobe}[https://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
% v1.7.2 twitter.com is now X.com; v1.7.3 but only use the new icon if it's been defined
\ifcsdef{simpleicon@xicon}
 {\NewInfoField{xtwitter}{\raisebox{-0.2ex}{\scalebox{0.95}{\simpleicon{x}}}\,}[https://x.com/]}
 {\let\xtwitter\twitter%
  \pretocmd{\xtwitter}{\ClassWarning{altacv}{You tried to use \string\xtwitter, but the new X icon isn't available. Please ensure you have updated the `simpleicons' package. Falling back to \string\twitter\space icon for now}}{}{}%
 }
\NewInfoField{linkedin}{\faLinkedin}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
% v1.7.3 Backward compatibility for ORCiD icon
\ifdef{\faOrcid}{
  \NewInfoField{orcid}{\faOrcid}[https://orcid.org/]
}{\iftutex
    \RequirePackage{academicons}
    \NewInfoField{orcid}{\aiOrcid\space}[https://orcid.org/]
  \else
    \ClassWarning{altacv}{ORCID icon for \string\orcid\space unavailable in pdflatex. Please compile with XeLaTeX or LuaLaTeX; or upgrade your LaTeX distribution and packages}
    \NewInfoField{orcid}{\fbox{O?}\space}[https://orcid.org/]
  \fi
}
\NewInfoField{location}{\cvLocationMarker}

% v1.2: Support for multiple photos
\newlength{\altacv@photos@width}
\newlength{\altacv@photo@diam@left}
\newlength{\altacv@photo@diam@right}
% ====================================== Begin of Added ======================================
\newlength{\altacv@header@offset}
% ====================================== End of Added ======================================

\def\altacv@left@photos{}
\def\altacv@right@photos{}

\newcommand{\@makeaphoto}[2]{%
  \begin{minipage}{#1}%
    \if@normalphoto
      \includegraphics[width=\linewidth]{#2}
    \else
      \tikz\path[fill overzoom image={#2}]circle[radius=0.5\linewidth];
    \fi%
  \end{minipage}%
}

\newcommand{\altacv@add@photo@left}[1]{%
  \appto{\altacv@left@photos}{%
    \@makeaphoto{\altacv@photo@diam@left}{#1}\hspace{1ex}%
  }%
  \addtolength{\altacv@photos@width}{\altacv@photo@diam@left}%
  \addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\altacv@add@photo@right}[1]{%
  \appto{\altacv@right@photos}{%
    \@makeaphoto{\altacv@photo@diam@right}{#1}\hspace{1ex}%
  }%
  \addtolength{\altacv@photos@width}{\altacv@photo@diam@right}%
  \addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\photoL}[2]{%
  \setlength{\altacv@photo@diam@left}{#1}%
  \forcsvlist{\altacv@add@photo@left}{#2}%
}
\newcommand{\photoR}[2]{%
  \setlength{\altacv@photo@diam@right}{#1}%
  \forcsvlist{\altacv@add@photo@right}{#2}%
}
\let\photo\photoR


% ====================================== Begin of Added ======================================
% 生成 QR 的包（pdfLaTeX / XeLaTeX 都可）
% ---- QR codes (optional)
\RequirePackage{qrcode} % 如果你想让 LaTeX 自动生成二维码。若用现成图片，可删掉这一行。


% --- 可在 header 左/右插入自定义盒子（不会被裁圆）
\newcommand{\headerboxR}[2]{%
  \setlength{\altacv@photo@diam@right}{#1}%
  \appto{\altacv@right@photos}{%
    \begin{minipage}{#1}\centering #2\end{minipage}\hspace{1ex}%
  }%
  \addtolength{\altacv@photos@width}{\altacv@photo@diam@right}%
  \addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\headerboxL}[2]{%
  \setlength{\altacv@photo@diam@left}{#1}%
  \appto{\altacv@left@photos}{%
    \begin{minipage}{#1}\centering #2\end{minipage}\hspace{1ex}%
  }%
  \addtolength{\altacv@photos@width}{\altacv@photo@diam@left}%
  \addtolength{\altacv@photos@width}{1ex}%
}


% ====================================== End of Added ======================================


\newcommand{\namefont}{\Huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\footnotesize\bfseries}
% ====================================== Begin of Modified ======================================
% \newcommand{\cvsectionfont}{\LARGE\bfseries}
% \newcommand{\cvsectionfont}{\large\bfseries}
\newcommand{\cvsectionfont}{\normalsize\bfseries}
% ====================================== End of Modified ======================================
\newcommand{\cvsubsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
  \begingroup
  % ====================================== Begin of Added ======================================
    % compute shift s.t. the name & tagline is centered (right - left)/2
    \setlength{\altacv@header@offset}
      {\dimexpr (\altacv@photo@diam@right - \altacv@photo@diam@left)/2\relax}%
    % ====================================== End of Added ======================================

    \altacv@left@photos\hfill%
    \begin{minipage}{\dimexpr\linewidth-\altacv@photos@width}%
    % ====================================== Begin of Modified ======================================
    % \raggedright%
    % \centering% center name & tagline instead, note no support for photos
    % {\namefont\color{name}\MakeUppercase{\@name}\par}
    % {\namefont\color{name}{\@name}\par}% drop upper casing
    {\namefont\color{name}%
        \noindent\makebox[0pt][l]{%
          \hspace*{\altacv@header@offset}%
          \makebox[\linewidth][c]{\@name}%
        }\par
    }
    % ====================================== End of Added ======================================
    % \medskip
    \smallskip
    % ====================================== Begin of Modified ======================================
    % {\taglinefont\color{tagline}\@tagline\par}
    {\taglinefont\color{tagline}%
        \noindent\makebox[0pt][l]{%
          \hspace*{\altacv@header@offset}%
          \makebox[\linewidth][c]{\@tagline}%
        }\par
    }
    % \medskip
    \smallskip
    % ====================================== End of Modified ======================================
    % ====================================== Begin of Added ======================================
    \raggedright
    % ====================================== End of Added ======================================
    {\personalinfofont\@personalinfo\par}
    \end{minipage}\hfill%
    \altacv@right@photos\par%
  \endgroup\medskip
}

\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

\newcommand{\cvsection}[2][]{%
  % ====================================== Begin of Modified ======================================
  % \nointerlineskip\bigskip%  %% bugfix in v1.6.2
  % \nointerlineskip\medskip%
  \vspace{1ex}
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
%   {\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
  {\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1.5ex]% make smaller gap
%   {\color{headingrule}\rule{\linewidth}{2pt}\par}\medskip
  {\color{headingrule}\rule{\linewidth}{0.75pt}\par}
  % \medskip% make smaller gap
  % \smallskip
  % \vspace{0.25ex}
  % ====================================== End of Modified ======================================
}


% ====================================== Begin of Added ======================================
\iftutex
  \newcommand\AccSuppMethod{plain}
\else
  \newcommand\AccSuppMethod{pdfstringdef}
\fi
% ====================================== End of Added ======================================


\newcommand{\cvsubsection}[1]{%
  \smallskip%
  {\color{subheading}\cvsubsectionfont{#1}\par}\medskip
}

% v1.1.4: fixes inconsistent font size
% v1.7: adds accsupp ActualText for location and date markers
\newcommand{\cvevent}[4]{%
  {\large\color{emphasis}#1\par}
  \smallskip\normalsize
  \ifstrequal{#2}{}{}{
  \textbf{\color{accent}#2}\par
  \smallskip}
  \ifstrequal{#3}{}{}{%
    {\small\makebox[0.5\linewidth][l]%
      % ====================================== Begin of Modified ======================================
      {\BeginAccSupp{method=pdfstringdef,ActualText={\datename:}}\cvDateMarker\EndAccSupp{}%
      % {\BeginAccSupp{method=\AccSuppMethod,ActualText={\datename:}}\cvDateMarker\EndAccSupp{}%
      ~#3}%
      % ====================================== End of Modified ======================================
    }}%
  \ifstrequal{#4}{}{}{%
    {\small\makebox[0.5\linewidth][l]%
      % ====================================== Begin of Modified ======================================
      {\BeginAccSupp{method=pdfstringdef,ActualText={\locationname:}}\cvLocationMarker\EndAccSupp{}%
      % {\BeginAccSupp{method=\AccSuppMethod,ActualText={\locationname:}}\cvLocationMarker\EndAccSupp{}%
        ~#4}%
      % ====================================== End of Modified ======================================
    }}\par
  \medskip\normalsize
}

% ====================================== Begin of Added ======================================
\newcommand{\cveventSameLine}[5]{% all content on the same line, date & time on the right
    \vspace{0.25ex}
    \ifstrequal{#1}{}{}{
      % {\large\color{emphasis}#1}
      % \BeginAccSupp{method=pdfstringdef,ActualText={Organization: #1 ^^J}}% enclose to add a AccSup newline; TODO: doesn't seem to work when #1 is itself a link with AccSupp
      %     {\large\color{emphasis}#1}
      % \EndAccSupp{}%
      % \pdfstringdef\temporg{#1}%
      % \edef\temporg{#1}%
      % \myBeginAccSupp{method=pdfstringdef,ActualText={Organization: \temporg ^^J}}%
      % \myBeginAccSupp{method=\AccSuppMethod,ActualText={Organization: \temporg ^^J}}%  otherwise it gives weird chinese characters
      % \edef\accTxtA{Organization: \unexpanded{#1} ^^J}%
      % \myBeginAccSupp{method=\AccSuppMethod,ActualText=\accTxtA}%
          % {\large\color{emphasis}#1}
          % {\textbf{\normalsize\color{emphasis}#1}}
          {\textbf{\small\color{emphasis}#1}}
      % \myEndAccSupp{}%
    }
  % }%
%   \smallskip
  % \normalsize
    \ifstrequal{#2}{}{}{
      % \textbf{\color{accent}#2}
      % \myBeginAccSupp{method=pdfstringdef,ActualText={^^JTitle: #2}}% enclose to add a AccSup newline; TODO: similar to above, doesn't work
      % \edef\accTxtB{^^JTitle: \unexpanded{#2}}%
      % \myBeginAccSupp{method=\AccSuppMethod,ActualText=\accTxtB}%
          % \textbf{\color{accent}#2}
          {\small\color{accent}#2}
      % \myEndAccSupp{}%
    % \smallskip
    }%
  \ifstrequal{#5}{}{}{
    \footnotesize~~~#5
  }
  \hfill
%   \ifstrequal{#3}{}{}{%
%   {\small\makebox[0.25\linewidth][r]%
%     {\BeginAccSupp{method=pdfstringdef,ActualText={\datename:}}\cvDateMarker\EndAccSupp{}%
%     ~#3}%
%   }}%
% \ifstrequal{#4}{}{}{%
%   {\small\makebox[0.25\linewidth][r]%
%     {\BeginAccSupp{method=pdfstringdef,ActualText={\locationname:}}\cvLocationMarker\EndAccSupp{}%
%       ~#4}%
%   }}\par
    \ifstrequal{#4}{}{}{%  # note right-most part becomes the date (previously location) for better visual alignment
      % {\small\makebox[0.1\linewidth][l]%
      %   \small
        \footnotesize
      %   ~~~{\BeginAccSupp{method=pdfstringdef,ActualText={\locationname:}}\cvLocationMarker\EndAccSupp{}%
      %   ~#4}%
          % include both to add a newline
          ~~~{
              % \myBeginAccSupp{method=pdfstringdef,ActualText={^^J\locationname: #4}}
                  % \cvLocationMarker~#4
              % \EndAccSupp{}%
              % \myBeginAccSupp{method=pdfstringdef,ActualText={Location:}}%
                % \cvLocationMarker%
              % \myEndAccSupp{}%
              \hideFromExtract{\cvLocationMarker}%
              ~#4%
          }%
          % ~~~{%
          %   \begingroup
          %     \edef\accTxtC{^^J\locationname: \unexpanded{#4}}%
          %     \myBeginAccSupp{method=\AccSuppMethod,ActualText=\accTxtC}%
          %       \cvLocationMarker~#4%
          %     \myEndAccSupp
          %   \endgroup
          % }%
      }
      % }
      % \par
  % }%
%   \medskip\normalsize
    \ifstrequal{#3}{}{}{%
  %   {\small\makebox[0.25\linewidth][l]%
        % \small
      % \footnotesize
      % ~~~{\BeginAccSupp{method=pdfstringdef,ActualText={\datename:}}\cvDateMarker\EndAccSupp{}%
      % ~#3}%
      % include both to add a newline
      ~~~{
          % \myBeginAccSupp{method=pdfstringdef,ActualText={^^J\datename: #3}}
              % \cvDateMarker~#3
          % \EndAccSupp{}%
          % \myBeginAccSupp{method=pdfstringdef,ActualText={Date:}}%
            % \cvDateMarker%
          % \myEndAccSupp{}%
          \hideFromExtract{\cvDateMarker}%
          ~#3%
          }%
      % ~~~{%
      %   \begingroup
      %     \edef\accTxtD{^^J\datename: \unexpanded{#3}}%
      %     \myBeginAccSupp{method=\AccSuppMethod,ActualText=\accTxtD}%
      %       \cvDateMarker~#3%
      %     \myEndAccSupp
      %   \endgroup
      % }%
    }%
  % \smallskip
  \vspace{0.25ex}  
  \normalsize
}
% ====================================== End of Added ======================================

% \newcommand{\cvevent}[5]{%
%   {\large\color{accent}#1
%     \ifstrequal{#5}{}{\par}{\hfill}  % If #5 specified, align #2 to the right
%   }
%   \smallskip\normalsize
%   \ifstrequal{#2}{}{\smallskip}{
%     \ifstrequal{#5}{}{\hfill}{}{\bfseries\color{emphasis}#2}\par\smallskip
%   }
%   \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\faCalendar~#3}}}%
%   \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\faMapMarker~#4}}}\par
%   \medskip\normalsize
% }

% v1.7: adds accsupp for the icon as well
\newcommand{\cvachievement}[3]{%
  \begin{tabularx}{\linewidth}{@{}p{2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
  \multirow{2}{*}{\Large\color{accent}\BeginAccSupp{method=escape,ActualText={#1: }}#1\EndAccSupp{}} & \bfseries\textcolor{emphasis}{#2}\\
  & #3
  \end{tabularx}%
  \smallskip
}

% ====================================== Begin of Modified ======================================
% \newcommand{\cvtag}[1]{%
%   \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
% }
\newcommand{\cvtag}[1]{%
  % \myBeginAccSupp{method=escape,ActualText={#1^^J}}%
  %   \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep=0.75ex,text height=1.5ex,text depth=.25ex]{#1};%
  % \myEndAccSupp{}%
  \tikz[baseline]\node[
      anchor=base,
      draw=body!30,rounded corners,
      inner xsep=1ex, inner ysep=0.75ex,
      text height=1.5ex, text depth=.25ex
    ]{%
      \myBeginAccSupp{method=pdfstringdef,ActualText={#1^^J}}#1\myEndAccSupp{}%
    };%
}
% ====================================== End of Modified ======================================

% ====================================== Begin of Added ======================================
% Add SVG support
\newcommand{\cvtagI}[2]{%
    % \myBeginAccSupp{method=escape,ActualText={#2^^J}}%
    % \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{\raisebox{-0.375 ex}{#1} #2};
    % \myEndAccSupp{}%
    \tikz[baseline]\node[
      anchor=base,
      draw=body!30,rounded corners,
      inner xsep=1ex, inner ysep=0.75ex,
      text height=1.5ex, text depth=.25ex
    ]{%
      \raisebox{-0.375ex}{#1}\,%
      \myBeginAccSupp{method=pdfstringdef,ActualText={#2^^J}}#2\myEndAccSupp{}%
    };%
}
% \newcommand{\cvtagI}[2]{%
%     \BeginAccSupp{method=escape,ActualText={#1^^J}}%
%         \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{\raisebox{-0.375 ex}{#1} #2};
%     \EndAccSupp{}%
% }
% ====================================== End of Added ======================================

% v1.6: Use accsupp so that the actual numeric value is copied/pasted
%       and also support 0.5, 1.5, 2.5, 3.5, 4.5
\newcommand{\cvskill}[2]{%
  \textcolor{emphasis}{\textbf{#1}}\hfill
  \BeginAccSupp{method=plain,ActualText={#2}}
  \foreach \x in {1,...,5}{%
    \ifdimequal{\x pt - #2 pt}{0.5pt}%
    {\clipbox*{0pt -0.25ex {.5\width} {\totalheight}}{\color{accent}\cvRatingMarker}%
     \clipbox*{{.5\width} -0.25ex {\width} {\totalheight}}{\color{body!30}\cvRatingMarker}}
    {\ifdimgreater{\x bp}{#2 bp}{\color{body!30}}{\color{accent}}\cvRatingMarker}%
  }\EndAccSupp{}\par%
}

% Adapted from @Jake's answer at http://tex.stackexchange.com/a/82729/226
\newcommand{\wheelchart}[4][0]{%
    \begingroup\centering
    \def\innerradius{#3}%
    \def\outerradius{#2}%
    % Calculate total
    \pgfmathsetmacro{\totalnum}{0}%
    \foreach \value/\colour/\name in {#4} {%
        \pgfmathparse{\value+\totalnum}%
        \global\let\totalnum=\pgfmathresult%
    }%
    \begin{tikzpicture}

      % Calculate the thickness and the middle line of the wheel
      \pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
      \pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}
      \pgfmathsetmacro{\totalrot}{-90 + #1}

      % Rotate so we start from the top
      \begin{scope}[rotate=\totalrot]

      % Loop through each value set. \cumnum keeps track of where we are in the wheel
      \pgfmathsetmacro{\cumnum}{0}
      \foreach \value/\width/\colour/\name in {#4} {
            \pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

            % Calculate the percent value
            \pgfmathsetmacro{\percentage}{\value/\totalnum*100}
            % Calculate the mid angle of the colour segments to place the labels
            \pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

            % This is necessary for the labels to align nicely
            \pgfmathparse{
               (-\midangle>180?"west":"east")
            } \edef\textanchor{\pgfmathresult}
            \pgfmathparse{
               (-\midangle>180?"flush left":"flush right")
            } \edef\textalign{\pgfmathresult}
            \pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

            % Draw the color segments. Somehow, the \midrow units got lost, so we add 'pt' at the end. Not nice...
            \filldraw[draw=white,fill=\colour] (-\cumnum:\outerradius) arc (-\cumnum:-(\newcumnum):\outerradius) --
            (-\newcumnum:\innerradius) arc (-\newcumnum:-(\cumnum):\innerradius) -- cycle;

            % Draw the data labels
            % v1.6: Use accsupp so that the numeric number is copied/pasted too
            \draw  [*-,thin,emphasis] node [append after command={(\midangle:\midradius pt) -- (\midangle:\outerradius + 1ex) -- (\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [xshift=\labelshiftdir*0.5cm,inner sep=1ex, outer sep=0pt, text width=\width,anchor=\textanchor,align=\textalign,font=\small,text=body]{\BeginAccSupp{method=pdfstringdef,ActualText={\name: \value}}\name\EndAccSupp{}};
            % Set the old cumulated angle to the new value
            \global\let\cumnum=\newcumnum
        }
      \end{scope}
%      \draw[gray] (0,0) circle (\outerradius) circle (\innerradius);
    \end{tikzpicture}\par
    \endgroup
}

\newcommand{\cvref}[3]{%
  \smallskip
  \textcolor{emphasis}{\textbf{#1}}\par
  \begin{description}[font=\color{accent},style=multiline,leftmargin=1.35em,align=left]
  \item[\small\normalfont\emailsymbol] #2
  \item[\small\normalfont\mailaddresssymbol] #3
  \end{description}
%   \medskip
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

% v1.5 Move biblatex-related code to separate .cfg file
% so that it's easier to change and customise the style for
% publication lists

% v1.1.2: make it easier to add a sidebar aligned with top of next page
\RequirePackage{afterpage}
\newcommand{\addsidebar}[2][]{\marginpar{%
  \ifstrequal{#1}{}{}{\vspace*{#1}}%
  \input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

% v1.6.5 But provide for ability to highlight names in publication list
\RequirePackage{pgffor}
\def\my@namelist{}
\newcommand{\mynames}[1]{\def\my@namelist{#1}}
\newtoggle{boldname}
% v1.7.3 For backward compatibility re hooks management
\IfFormatAtLeastTF{2021-11-15}{%
  \AddToHook{package/biblatex/after}{%
    \typeout{OK AddToHook biblatex after works}
    \altacv@makeboldnames
  }%
}{%
  \AfterPackage{biblatex}{%
    \typeout{OK AfterPackage biblatex after works}
    \altacv@makeboldnames
  }%
}

\newcommand{\altacv@makeboldnames}{%
  \renewcommand*{\mkbibnamefamily}[1]{%
    \global\togglefalse{boldname}%
    \foreach \my@fname / \my@gname in \my@namelist {%
      \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                   and
                   test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
        {\global\toggletrue{boldname}\typeout{YES BOLD NAMES}}{}%
    }%
    \iftoggle{boldname}{\textbf{##1}}{##1}%
  }%
%
  \renewcommand*{\mkbibnamegiven}[1]{%
    \global\togglefalse{boldname}%
    \foreach \my@fname / \my@gname in \my@namelist{%
      \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                   and
                   test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
        {\global\toggletrue{boldname}\breakforeach}{}%
    }%
    \iftoggle{boldname}{\textbf{##1}}{##1}%
  }
}

% 1.7.3 Backward compatibility for hooks management
\IfFormatAtLeastTF{2020-10-01}{%
  \AddToHook{begindocument/before}{%
    \pagestyle{empty}%
    \color{body}%
    \raggedright%
  }
}{%
  \AtBeginDocument{%
    \pagestyle{empty}%
    \color{body}%
    \raggedright%
  }
}
