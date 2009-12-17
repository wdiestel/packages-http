/*  Part of SWI-Prolog

    Author:        Jan Wielemaker
    E-mail:        J.Wielemaker@cs.vu.nl
    WWW:           http://www.swi-prolog.org
    Copyright (C): 2009, VU University, Amsterdam

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    As a special exception, if you link this library with other files,
    compiled with a Free Software compiler, to produce an executable, this
    library does not by itself cause the resulting executable to be covered
    by the GNU General Public License. This exception does not however
    invalidate any other reasons why the executable file might be covered by
    the GNU General Public License.
*/

:- module(http_server_files, []).
:- use_module(library(http/http_path)).
:- use_module(library(http/http_dispatch)).

/** <module> Serve files needed by modules from the server

*/

:- multifile
	http:location/3.		% Alias, Expansion, Options
:- dynamic
	http:location/3.		% Alias, Expansion, Options

http:location(icons, root(icons), [ priority(-100) ]).
http:location(css,   root(css),   [ priority(-100) ]).

:- multifile
	user:file_search_path/2.
:- dynamic
	user:file_search_path/2.

user:file_search_path(icons, library('http/web/icons')).
user:file_search_path(css,   library('http/web/css')).

:- http_handler(icons(.), serve_files_in_directory(icons), [prefix]).
:- http_handler(css(.),   serve_files_in_directory(css),   [prefix]).

%%	serve_files_in_directory(+Alias, +Request)
%
%	Serve files from the directory  Alias   from  the path-info from
%	Request.

serve_files_in_directory(Alias, Request) :-
	memberchk(path_info(PathInfo), Request),
	Term =.. [Alias,PathInfo],
	http_reply_file(Term, [], Request).
