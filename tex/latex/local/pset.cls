%% TODO: Write .dtx documentation file

\NeedsTeXFormat{LaTeX2e}			%% Some expl3 macros are used...(?)
\ProvidesClass{pset}[2020/06/15 Template for physics problem sets.]

%% Most of the time, this package will be used with include.sty, so some of these
%% are redundant.  NBD
%% THE ORDER MATTERS SO DON'T FUCK WITH IT
\LoadClass{article}
\RequirePackage{fancyhdr}
\RequirePackage{xparse}
\RequirePackage{mdframed}
\RequirePackage{listofitems}
\RequirePackage{intcalc}
\RequirePackage{xifthen}
\RequirePackage{geometry}
\RequirePackage{titling}
\RequirePackage{amsthm}
\RequirePackage{amsmath}
\RequirePackage{mathtools}

%% Not sure yet what to do about the "geometry" setters below
%\setlength{\textwidth}{\paperwidth}
%\addtolength{\textwidth}{-2in}
%\calclayout

\geometry{lmargin=.75in, rmargin=.75in}


%% Layout environments and macros
\makeatletter								%% To allow use of "private" variables, TeX-style

\newcounter{problem}						%% Tracks the problem number
\newcounter{problempart}					%% Tracks which part of the problem we're on
\newcounter{problemstart}					%% Tracks which page the problem starts on

\setcounter{problem}{0}
\setcounter{problemstart}{1}	

%% Commands used to track display properties associated with individual problems
%% Not defined as "hidden" (i.e., using @ symbol) because there are limited use-cases
%% in which these might need to be accessible from an ordinary .tex file.
\newcommand{\theheadertitle}{}
\newcommand{\theproblemtitle}{}
\newcommand{\theproblemsubtitle}{}
\newcommand{\theproblemformattedtitle}{}
\newcommand{\usecustomppartlist}{\BooleanFalse}
\newcommand{\problempartformatkey}{a}
\newcommand{\theproblempartformattedname}{}
\newcommand{\theproblempartname}{}
\newcommand{\theproblemheadertext}{}
\newcommand{\theproblempage}{\the\numexpr\thepage-\theproblemstart+1\relax}
	%% Implements simple, "old-fashioned TeX"-style arithmetic to calculate how many pages 
	%% we've been working on this problem for
	
\newcommand{\defaultppartlist}{
	a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
}

%\readlist\problempartlist{\defaultppartlist}

%% The \NewDocumentEnvironment macro is defined in the xparse package.
%% I use it here because it provides simple, easy-to-use support for multiple configurable
%% option arguments.

%% Definition of the "problem" environment.
%% Options: 
%% 1. Problem title (optional arg; defaults to "Problem <problemnum>"
%% 2. Problem subtitle (optional; defaults to empty
\NewDocumentEnvironment{problem}{ o o }
{
	\refstepcounter{problem}				%% Increments "problem" counter
	\setcounter{problemstart}{\thepage}		%% Initializes problemstart page counter
	\setcounter{problempart}{0}				%% Initializes "problempart" numerical counter
	\IfNoValueTF{#1}						%% Set title based on 1st optional arg
		{\renewcommand{\theproblemtitle}{Problem \theproblem}}
		{\renewcommand{\theproblemtitle}{#1}}	
	\IfNoValueTF{#2}						%% Set subtitle based on 2nd optional arg
		{
			\renewcommand{\theproblemsubtitle}{}
			\renewcommand{\theproblemformattedtitle}{\textbf{\theproblemtitle}}%
		}
		{
			\renewcommand{\theproblemsubtitle}{#2}
			\renewcommand{\theproblemformattedtitle}{\textbf{\theproblemtitle} (\theproblemsubtitle)}
		}	
	\renewcommand{\theproblemheadertext}{\theproblemtitle \, -- \, \theproblempage}
	
%	\protected@edef\@currentlabelname{\theproblemtitle}
%% Not sure what this line was supposed to accomplish

	%% Format problem "title bar"
	\noindent \hrule height .5pt width \textwidth
	\vskip .75em
	\begin{center}
		\large{\theproblemformattedtitle}
	\end{center}
	\noindent \hrule height .5pt width \textwidth
	\vskip .75em
}{	\newpage }

\newcommand{\ifequals}[3]{\ifthenelse{\equal{#1}{#2}}{#3}{}}
\newcommand{\case}[2]{#1 #2} % Dummy, so \renewcommand has something to overwrite...
\newenvironment{switch}[1]{\renewcommand{\case}{\ifequals{#1}}}{}

\newcommand{\getppartname}[1]
{
	\begin{switch}{#1}
		\case{a}{\alph{problempart}}
		\case{A}{\Alph{problempart}}
		\case{i}{\roman{problempart}}
		\case{I}{\Roman{problempart}}
		\case{1}{\arabic{problempart}}
	\end{switch}
}

\NewDocumentEnvironment{problemprime}{ o o O{a} e{^} }
{
	\refstepcounter{problem}				%% Increments "problem" counter
	\setcounter{problemstart}{\thepage}		%% Initializes problemstart page counter
	\setcounter{problempart}{0}				%% Initializes "problempart" numerical counter
	\IfNoValueTF{#4}
		{
			\renewcommand{\usecustomppartlist}{\BooleanFalse}
			\renewcommand{\problempartformatkey}{#3}
		}
		{
			\renewcommand{\usecustomppartlist}{\BooleanTrue}
			\readlist\problempartlist{#4}
		}
	\IfNoValueTF{#1}						%% Set title based on 1st optional arg
		{\renewcommand{\theproblemtitle}{Problem \theproblem}}
		{\renewcommand{\theproblemtitle}{#1}}	
	\IfNoValueTF{#2}						%% Set subtitle based on 2nd optional arg
		{
			\renewcommand{\theproblemsubtitle}{}
			\renewcommand{\theproblemformattedtitle}{\textbf{\theproblemtitle}}%
		}
		{
			\renewcommand{\theproblemsubtitle}{#2}
			\renewcommand{\theproblemformattedtitle}{\textbf{\theproblemtitle} (\theproblemsubtitle)}
		}	
	\renewcommand{\theproblemheadertext}{\theproblemtitle \, -- \, \theproblempage}
	
%	\protected@edef\@currentlabelname{\theproblemtitle}
%% Not sure what this line was supposed to accomplish

	%% Format problem "title bar"
	\noindent \hrule height .5pt width \textwidth
	\vskip .75em
	\begin{center}
		\large{\theproblemformattedtitle}
	\end{center}
	\noindent \hrule height .5pt width \textwidth
	\vskip .75em
}{	\newpage }

\NewDocumentCommand{\problempartprime}{ tp tb t. t| }
{
	\refstepcounter{problempart}
	\IfBooleanTF{\usecustomppartlist}
		{
			\renewcommand{\theproblempartname}{\problempartlist[\intcalcMod{\theproblempart}{\problempartlistlen} + 1]	}		
		}
		{
			\renewcommand{\theproblempartname}{\getppartname{\problempartformatkey}}
		}
	\IfBooleanTF{#3}
		{\renewcommand{\theproblempartformattedname}{\theproblempartname~.}}
		{\renewcommand{\theproblempartformattedname}{\theproblempartname} }
	\IfBooleanTF{#1}
		{\renewcommand{\theproblempartformattedname}{(\theproblempartformattedname)}}
		{ }
	\IfBooleanTF{#2}
		{\renewcommand{\theproblempartformattedname}{\textbf{\theproblempartformattedname}}}
		{ }
	\IfBooleanTF{#4}
		{\renewcommand{\theproblempartformattedname}{\fbox{\theproblempartformattedname}	}}
		{ }		
	\theproblempartformattedname
}

%% Definition of the "problemstatement" environment.
%% Options:
%% 1. Text to appear at top of "problemstatement" box (optional; default is "Problem Statement")
%% 2. Text option (optional; default is \itshape to give italicized text)
%% 3. Background color of problemstatement text box (optional; default is "lightgray")
\NewDocumentEnvironment{problemstatement}{ O{Problem Statement} O{\itshape} O{lightgray} }%
{
	\begin{mdframed}[backgroundcolor=#3, frametitle={#1}]#2
}{	\end{mdframed}}


%% Definition of the "problempart" environment.
%% Options:
%% 1. Problem part name (optional; defaults to Latin lower-case letter corresponding to problempart number)
%% 2. Boolean triggered by the presence of the token "p" in the argument list.  Indicates whether to include parentheses around the problempart name.
%% 3. Boolean triggered by the presence of the token "b" in the argument list.  Indicates whether to "box" the problempart name.
\NewDocumentEnvironment{problempart}{ o tp tb }
{
	\refstepcounter{problempart}
	\IfNoValueTF{#1}
		{\renewcommand{\theproblempartname}{\alph{\theproblempart}}	}%
		{\renewcommand{\theproblempartname}{#1}	}
	\IfBooleanTF{#2}
		{\renewcommand{\theproblempartformattedname}{\textbf{(\theproblempartname)}}}
		{\renewcommand{\theproblempartformattedname}{\textbf{\theproblempartname}}	}%
	\IfBooleanTF{#3}
		{\renewcommand{\theproblempartformattedname}{\fbox{(\theproblempartformattedname)}	}}
		{ }
	\theproblempartformattedname
}{}

\providecommand{\problempartautorefname}{Part}
	%% The purpose of this command is to make sure problem parts are referenced correctly
	%% by autoref calls, e.g., \ref{part_a} results in "Part (a)" instead of "a".

\NewDocumentEnvironment{problempartsimple}{ o }
{
	\refstepcounter{problempart}
	\IfNoValueTF{#1}%
		{\renewcommand{\theproblempartname}{(\alph{problempart})}	}%
		{\renewcommand{\theproblempartname}{#1}	}
	\renewcommand{\theproblempartformattedname}{\fbox{\large{\textbf{\theproblempartname}}}}
	\vspace{1em}
	\theproblempartformattedname \quad
}

\NewDocumentEnvironment{problempartsimple*}{ o }
{
	\refstepcounter{problempart}
	\IfNoValueTF{#1}%
		{\renewcommand{\theproblempartname}{(\alph{\theproblempart})}	}%
		{\renewcommand{\theproblempartname}{#1}	}
	\renewcommand{\theproblempartformattedname}{\large{\textbf{\theproblempartname}}}
	\theproblempartformattedname \quad
}
\makeatother

\newcommand{\headertitle}[1]{\renewcommand{\theheadertitle}{#1}}
\numberwithin{equation}{problem}

%% Describe layout of title
\pretitle{
  \begin{center}
    \Large\bfseries
}
\posttitle{
  \end{center}
%  \noindent\vrule height 2.5pt width \textwidth
}
\preauthor{
  \begin{center}
  \begin{tabular}[t]{@{}l@{}}%
}
\postauthor{
    \end{tabular}
    \vskip -.5em
    \par
  \end{center}
}
\predate{
  \begin{center}
}
\postdate{
  \end{center}
}

%% Use fancyhdr package to set default header / footer text
\pagestyle{fancy}
\fancyhf{}
\fancyhf[lf]{\thedate{}}
\fancyhf[rf]{\thepage}
\fancyhf[lh]{\theheadertitle}
\fancyhf[ch]{\theproblemheadertext}
\fancyhf[rh]{\theauthor}
\setlength{\footskip}{30pt}
\renewcommand{\footrulewidth}{.4pt}
\renewcommand{\footrule}{\hrule height \footrulewidth width \textwidth}