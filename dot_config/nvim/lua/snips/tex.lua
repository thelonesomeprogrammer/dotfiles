local ls = require 'luasnip'
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local extended_euclidean_algorithm = function(index)
  return f(function(indput)
    -- Check if both arguments are integers
    indput = vim.split(indput[1][1], ",", true)
    a = tonumber(indput[1])
    b = tonumber(indput[2])
    if type(a) ~= "number" or type(b) ~= "number" then
      return ""
    end

    -- Initialize variables
    local s, old_s = 0, 1
    local t, old_t = 1, 0
    local r, old_r = math.min(b, a), math.max(b, a)

    -- Initialize LaTeX string
    local latex = ""

    -- Perform the algorithm
    while r ~= 0 do
      local quotient = math.floor(old_r / r)
      local precal_old_s, precal_s = old_s, s
      local precal_old_t, precal_t = old_t, t
      old_r, r = r, old_r - quotient * r
      old_s, s = s, old_s - quotient * s
      old_t, t = t, old_t - quotient * t

      -- Add current step to LaTeX string
      if r ~= 0 then
        latex = latex .. "$$" .. quotient * old_r + r .. "=" .. quotient .. "*" .. old_r .. "+" ..r .. "\\qand " .. "s=" .. 
        precal_old_s .. "-" .. quotient .. "*" .. precal_s .. "\\qand " .. "t=" .. precal_old_t .. "-" .. quotient .. "*" .. precal_t .. "$$"
      else
        latex = latex .. "$$" .. quotient * old_r + r .. "=" ..
        quotient .. "*" .. old_r .. "+" .. r .. "\\qand " .. "s=" .. precal_s .. "\\qand " .. "t=" .. precal_t .. "$$"
      end
    end

    -- Add final step to LaTeX string
    latex = latex .. "$$sfd=" .. old_r .. "\\qand s=" .. old_s .. "\\qand t=" .. old_t .. "$$"
    -- Return the LaTeX string
    return latex
  end, { index })
end


table_node = function(args)
  local tabs = {}
  local count
  table = args[1][1]:gsub("%s", ""):gsub("|", "")
  count = table:len()
  for j = 1, count do
    local iNode
    iNode = i(j)
    tabs[2 * j - 1] = iNode
    if j ~= count then
      tabs[2 * j] = t " & "
    end
  end
  return sn(nil, tabs)
end

rec_table = function()
  return sn(nil, {
    c(1, {
      t({ "" }),
      sn(nil, { t { "\\\\", "" }, d(1, table_node, { ai[1] }), d(2, rec_table, { ai[1] }) })
    }),
  });
end


local derive = function(args)
  local f = args[2][1]
  local string = "" .. f .. "({})"
  local reps = { i(1) }
  for i = 1, #args[1][1] do
    if args[1][1]:sub(i, i) == "d" then
      string = string.format("derivative(%s,{})", string)
      table.insert(reps, rep(1))
    end
  end
  return sn(nil, fmt(string, reps))
end


ls.add_snippets("tex", {
  s("sagesilent", fmt("\\begin{{sagesilent}}\n{}\\end{{sagesilent}}", { i(1) })),
  s("linjens parameter", fmt(
    [[\subsubsection{{metode}}
linjens parameterfremstilling består af et punkt og en retnings vector. den linje der går gennem {} og {} kan derfor findes som {} lagt sammen med t ganget på $\vec{{{}{}}}$ som er {} - {} som en vector
\subsubsection{{udringning}}
\begin{{sagesilent}}
  {} = vector([{}])
  {} = vector([{}])
  {}{} = {}+{}
\end{{sagesilent}}
$${} = (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})\qand {} = (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})$$
$$\vec{{{}{}}} = (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}}) - (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}}) = \(\sage{{{}[0]}} - \sage{{{}[0]}} \\ \sage{{{}[1]}} - \sage{{{}[1]}} \\ \sage{{{}[2]}}-\sage{{{}[2]}}\)=\(\sage{{{}{}[0]}} \\ \sage{{{}{}[1]}} \\ \sage{{{}{}[2]}}\)$$
$$l= {}+t\*\vec{{{}{}}}=(\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})+t\*\(\sage{{{}{}[0]}} \\ \sage{{{}{}[1]}} \\ \sage{{{}{}[2]}}\)$$
\subsubsection{{svar}}
parameterfremstilling for injen er $\(x\\y\\z\)=(\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})+t\*\\(\sage{{{}{}[0]}},\sage{{{}{}[1]}},\sage{{{}{}[2]}}\)$]],
    { i(1, ''), i(2, ''), rep(1), rep(1), rep(2), rep(2), rep(1), rep(1), i(3, ''), rep(2), i(4, ''), rep(1), rep(2),
      rep(1), rep(2), rep(1), rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(2), rep(1), rep(2), rep(2), rep(2),
      rep(2), rep(1), rep(1), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(1), rep(2), rep(1), rep(2),
      rep(1), rep(2), rep(1), rep(1), rep(2), rep(1), rep(1), rep(1), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2),
      rep(1), rep(1), rep(1), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), })
  ),
  s("planens ligning", fmt(
    [[\subsubsection{{metode}}
planens ligning består af en normal vector til panen og et punkt i planen normal vectoren kan findes som kryds puductet af 2 vectorer i planen der ikke er paralele. de to vectorer kan findes udfra de 3 punkter {}, {} og {} ved at opsætte vector $\vec{{{}{}}}$ og vector $\vec{{{}{}}}$. og vi har et punkt i planen i from af {} eller {} eller {}.
\subsubsection{{udringning}}
\begin{{sagesilent}}
  var("x,y,z")
  {} = vector([{}])
  {} = vector([{}])
  {} = vector([{}])
  {}{} = {}-{}
  {}{} = {}-{}
  {}{}{} = {}{}.cross_product({}{})
  {} = {}{}{}[0]*x+{}{}{}[1]*y+{}{}{}[2]*z-{}{}{}[0]*{}[0]+{}{}{}[1]*{}[1]+{}{}{}[2]*{}[2]
\end{{sagesilent}}
$${} = (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})\qand {} = (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})\qand {} = (\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})$$
$$\vec{{{}{}}}={}-{}=(\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})-(\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})=\(\sage{{{}[0]}}-\sage{{{}[0]}} \\ \sage{{{}[1]}}-\sage{{{}[0]}} \\ \sage{{{}[2]}}-\sage{{{}[0]}}\)$$
$$\vec{{{}{}}}=\(\sage{{{}{}[0]}} \\ \sage{{{}{}[1]}} \\ \sage{{{}{}[2]}}\)$$
$$\vec{{{}{}}}={}-{}=(\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})-(\sage{{{}[0]}},\sage{{{}[1]}},\sage{{{}[2]}})=\(\sage{{{}[0]}}-\sage{{{}[0]}} \\ \sage{{{}[1]}}-\sage{{{}[1]}} \\ \sage{{{}[2]}}-\sage{{{}[2]}}\)$$
$$\vec{{{}{}}}=\(\sage{{{}{}[0]}} \\ \sage{{{}{}[1]}} \\ \sage{{{}{}[2]}}\)$$
$$\vec{{{}{}{}}}=\vec{{{}{}}}\times\vec{{{}{}}}=\(\sage{{{}{}{}[0]}} \\ \sage{{{}{}{}[1]}} \\ \sage{{{}{}{}[2]}}\)$$
$$\sage{{{}{}{}[0]}}x+\sage{{{}{}{}[1]}}y+\sage{{{}{}{}[2]}}z-\sage{{{}{}{}[0]}}\*\sage{{{}[0]}}-\sage{{{}{}{}[1]}}\*\sage{{{}[1]}}-\sage{{{}{}{}[2]}}\*\sage{{{}[3]}}=0$$
$$\sage{{{}}}$$
\subsubsection{{svar}}
ligningen for ${}$ er $\sage{{{}}}$]],
    { i(1, ''), i(2, ''), i(3, ''), rep(2), rep(1), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1), i(4, ''), rep(2),
      i(5, ''), rep(3), i(6, ''), rep(2), rep(1), rep(1), rep(2), rep(2), rep(3), rep(3), rep(2), rep(2), rep(3), rep(1),
      rep(2), rep(3), rep(2),
      rep(1), i(7, ''), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1),
      rep(2), rep(2), rep(3), rep(1), rep(2), rep(2), rep(3), rep(1), rep(2), rep(1), rep(1), rep(1), rep(1), rep(2),
      rep(2), rep(2), rep(2), rep(3), rep(3), rep(3), rep(3), rep(2),
      rep(3), rep(3), rep(2), rep(3), rep(3), rep(3), rep(2), rep(2), rep(2), rep(3), rep(2), rep(3), rep(2), rep(3),
      rep(2), rep(2), rep(3), rep(2), rep(3), rep(2), rep(3), rep(2), rep(3), rep(2), rep(1), rep(1), rep(2), rep(1),
      rep(1), rep(1), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1),
      rep(2), rep(1), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(3), rep(1),
      rep(2), rep(3), rep(2), rep(1), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1), rep(2),
      rep(3), rep(1), rep(2), rep(3), rep(1), rep(2), rep(3), rep(1),
      rep(2), rep(3), rep(1), rep(2), rep(2), rep(3), rep(1), rep(2), rep(2), rep(3), rep(1), rep(2), rep(7), rep(7),
      rep(7) })),
  s("vinkel plan", fmt(
    [[\subsubsection{{metode}}
vinkel mellem de to plan er $\arccos\(\frac{{\vec{{{}_n}}\* \vec{{{}_n}}}}{{|\vec{{{}_n}}|\*|\vec{{{}_n}}|}}\)$ hvor ${}_n$ er normal vectoren til {} og ${}_n$ er normal vectoren til {}
\subsubsection{{udringning}}
\begin{{sagesilent}}
  {}n = vector([{}])
  {}n = vector([{}])
  {}l = {}n.norm()
  {}l = {}n.norm()
  {}d{} = {}n.dot_product({}n)
  {}{}v = acos({}d{}/({}l*{}l))*180/pi
\end{{sagesilent}}
$$\vec{{{}_n}}=\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\qand \vec{{{}_n}}=\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)$$
$$\arccos\(\frac{{\vec{{{}_n}}\*\vec{{{}_n}}}}{{|\vec{{{}_n}}|\*|\vec{{{}_n}}|}}\)$$
$$\arccos\(\frac{{\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\*\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)}}{{\left|\\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\right|\*\left|\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\right|}}\)$$
$$\arccos\(\frac{{\sage{{{}d{}}}}}{{\sage{{{}l}}\*\sage{{{}l}}}}\)$$
$$\sage{{crop({}{}v)}}\deg$$
\subsubsection{{svar}}
vinklen mellem {} planen og {} er $\sage{{crop({}{}v)}}\deg$]],
    { i(1, ''), i(2, ''), rep(1), rep(2), rep(1), rep(1), rep(2), rep(2), rep(1), i(3, ''), rep(2), i(4, ''), rep(1),
      rep(1), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2),
      rep(1), rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(1),
      rep(1), rep(2), rep(2), rep(2), rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2),
      rep(1), rep(2), rep(2), rep(1), rep(1), rep(2) })),
  s("vinkel linjer", fmt(
    [[\subsubsection{{metode}}
vinkel mellem de to linjer er $\arccos\(\frac{{\vec{{{}_r}}\* \vec{{{}_r}}}}{{|\vec{{{}_r}}|\*|\vec{{{}_r}}|}}\)$ hvor ${}_r$ er retnigs vectoren til {} og ${}_r$ er retnigs vectoren til {}
\subsubsection{{udringning}}
\begin{{sagesilent}}
  {}n = vector([{}])
  {}n = vector([{}])
  {}l = {}n.norm()
  {}l = {}n.norm()
  {}d{} = {}n.dot_product({}n)
  {}{}v = acos({}d{}/({}l*{}l))*180/pi
\end{{sagesilent}}
$$\vec{{{}_r}}=\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\qand \vec{{{}_r}}=\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)$$
$$\arccos\(\frac{{\vec{{{}_r}}\*\vec{{{}_r}}}}{{|\vec{{{}_r}}|\*|\vec{{{}_r}}|}}\)$$
$$\arccos\(\frac{{\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\*\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)}}{{\left|\\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\right|\*\left|\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\right|}}\)$$
$$\arccos\(\frac{{\sage{{{}d{}}}}}{{\sage{{{}l}}\*\sage{{{}l}}}}\)$$
$$\sage{{crop({}{}v)}}\deg$$
\subsubsection{{svar}}
vinklen mellem {} og {} er $\sage{{crop({}{}v)}}\deg$]],
    { i(1, ''), i(2, ''), rep(1), rep(2), rep(1), rep(1), rep(2), rep(2), rep(1), i(3, ''), rep(2), i(4, ''), rep(1),
      rep(1), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1),
      rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(1), rep(1),
      rep(2), rep(2), rep(2), rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1),
      rep(2), rep(2), rep(1), rep(1), rep(2) })),
  s("vinkel plan linje", fmt(
[[\subsubsection{{metode}}
vinkel mellem et plan og en linje er $\arccos\(\frac{{\vec{{{}_n}}\* \vec{{{}_r}}}}{{|\vec{{{}_n}}|\*|\vec{{{}_r}}|}}\)$ hvor ${}_n$ er normal vectoren til {} og ${}_r$ er retnigs vectoren til {}
\subsubsection{{udringning}}
\begin{{sagesilent}}
  {}n = vector([{}])
  {}n = vector([{}])
  {}l = {}n.norm()
  {}l = {}n.norm()
  {}d{} = {}n.dot_product({}n)
  {}{}v = acos({}d{}/({}l*{}l))*180/pi
\end{{sagesilent}}
$$\vec{{{}_n}}=\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\qand \vec{{{}_r}}=\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)$$
$$\arccos\(\frac{{\vec{{{}_n}}\*\vec{{{}_r}}}}{{|\vec{{{}_n}}|\*|\vec{{{}_r}}|}}\)$$
$$\arccos\(\frac{{\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\*\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)}}{{\left|\\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\right|\*\left|\(\sage{{{}n[0]}} \\ \sage{{{}n[1]}} \\ \sage{{{}n[2]}}\)\right|}}\)$$
$$\arccos\(\frac{{\sage{{{}d{}}}}}{{\sage{{{}l}}\*\sage{{{}l}}}}\)$$
$$\sage{{crop({}{}v)}}\deg$$
\subsubsection{{svar}}
vinklen mellem {} og {} er $\sage{{crop({}{}v)}}\deg$]],
    { i(1, ''), i(2, ''), rep(1), rep(2), rep(1), rep(1), rep(2), rep(2), rep(1), i(3, ''), rep(2), i(4, ''), rep(1),
      rep(1), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1),
      rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(1), rep(1),
      rep(2), rep(2), rep(2), rep(1), rep(1), rep(1), rep(2), rep(2), rep(2), rep(1), rep(2), rep(1), rep(2), rep(1),
      rep(2), rep(2), rep(1), rep(1), rep(2) })),
  s("vector func", fmt(
[[var("{}")
{}=vector([{},{}])
parametric_plot({}({}=x), ({},{}))]], {i(1, "t"), i(2, "f"), i(3), i(4), rep(2), rep(1), i(5), i(6)})),
  s("figure", fmt(
[[\begin{{figure}}[H]
\includegraphics[width = 400pt]{{{}}}
\centering
\caption{{{}}}
\end{{figure}}]], { i(1, "x.png"), i(2) })),
  s("euklides", fmt([[{}{}]], { i(1, "1,2"), extended_euclidean_algorithm(1) })),
  s("table",
    { t "\\begin{tabular}{", i(1, "0"), t { "}", "" }, d(2, table_node, { 1 }, {}), d(3, rec_table, { 1 }), t { "", "\\end{tabular}" } }),
  s("derivative", { i(1, "d"), i(2, "f"), t " = ", d(3, derive, { 1, 2 }) }),
  s("find_root", fmt([[find_root({}({})=={},{},{})]], { i(1, "f"), i(2, "x"), i(3, "0"), i(4), i(5) })),

}
)
