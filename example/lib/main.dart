import 'package:example/code_theme_selector.dart';
import 'package:example/theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:inception/inception.dart';
import 'package:kalua/kalua.dart';

void main() {
  runApp(const KaluaEditorApp());
}

class KaluaEditorApp extends StatelessWidget {
  const KaluaEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Kalua', home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CodeDocument _code;

  KaluaTheme _theme = githubLightKaluaTheme;
  late LuauSyntaxHighlighter _highlighter;

  @override
  void initState() {
    super.initState();

    _highlighter = LuauSyntaxHighlighter(_theme.luauTheme);
    _code = CodeDocument(_exampleCode);

    _highlightSyntax();
  }

  void _updateTheme(KaluaTheme newTheme) {
    setState(() {
      _theme = newTheme;
      _highlightSyntax();
    });
  }

  void _highlightSyntax() {
    _highlighter.detachFromDocument();

    // TODO: Expose ability to mutate the theme on the highlighter.
    _highlighter = LuauSyntaxHighlighter(_theme.luauTheme);
    _highlighter.attachToDocument(_code);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: _theme.brightness),
      child: Scaffold(
        backgroundColor: _theme.editorTheme.paneColor,
        body: Column(
          children: [
            // App bar
            const SizedBox(height: 54),
            Container(width: double.infinity, height: 1, color: _theme.editorTheme.paneDividerColor),
            // Code editor
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: _theme.editorTheme.background,
                      child: CodeLines(
                        codeLines: [
                          for (int i = 0; i < _highlighter.lineCount; i += 1) //
                            _highlighter.getStyledLineAt(i)!,
                        ],
                        gutterColor: _theme.editorTheme.gutterBackground,
                        gutterBorderColor: _theme.editorTheme.gutterBorder,
                        lineBackgroundColor: _theme.editorTheme.background,
                        indentLineColor: _theme.editorTheme.indentLineColor,
                        baseTextStyle: TextStyle(
                          color: _theme.editorTheme.foreground,
                          fontSize: 14,
                          fontFamily: "SourceCodePro",
                        ),
                      ),
                    ),
                  ),
                  ThemeConfiguratorPane(theme: _theme, onThemeChange: _updateTheme),
                ],
              ),
            ),
            // Bottom bar
            _BottomBar(
              currentTheme: _theme,
              dividerColor: _theme.editorTheme.paneDividerColor,
              onThemeSelected: (newTheme) {
                setState(() {
                  _theme = newTheme;
                  _highlighter.detachFromDocument();
                  _highlighter = LuauSyntaxHighlighter(_theme.luauTheme);
                  _highlighter.attachToDocument(_code);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.currentTheme, required this.dividerColor, required this.onThemeSelected});

  final KaluaTheme currentTheme;

  final Color dividerColor;

  final void Function(KaluaTheme) onThemeSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: dividerColor)),
      ),
      child: Center(
        child: CodeThemeSelector(
          currentTheme: currentTheme,
          onThemeSelected: (newTheme) {
            if (newTheme == null) {
              // Fizzle.
              return;
            }

            onThemeSelected(newTheme);
          },
        ),
      ),
    );
  }
}

final _exampleCode = '''--[[
    Full Luau Syntax Showcase
    Demonstrates variables, functions, classes, types, metatables, tables,
    loops, control flow, operators, coroutines, modules, and more.
]]

-------------------------
-- Types and Type Aliases
-------------------------

type NumberOrString = number | string
type OptionalInt = number?
type Vec2 = { x: number, y: number }
type StringMap<T> = { [string]: T }
export type PlayerInfo = { name: string, score: number }

-------------------------
-- Enum via literal union
-------------------------
type Team = "Red" | "Blue" | "Green"

-------------------------
-- Generic Function
-------------------------

local function identity<T>(value: T): T
    return value
end

-------------------------
-- Variables
-------------------------

local count: number = 0
local name: string = "Luau Example"
local mixed: NumberOrString = "hello"

-------------------------
-- Tables (arrays, dicts, mixed)
-------------------------

local numbers = { 1, 2, 3 }
local dict = { a = 10, b = 20 }
local mixedTable = { "hi", x = 5, { nested = true } }

-------------------------
-- Metatables (OOP Style)
-------------------------

local Vector = {}
Vector.__index = Vector

export type Vector = { x: number, y: number }

function Vector.new(x: number, y: number): Vector
    return setmetatable({ x = x, y = y }, Vector)
end

function Vector:Length(): number
    return math.sqrt(self.x * self.x + self.y * self.y)
end

-- __tostring metamethod
function Vector.__tostring(self)
    return "(" .. self.x .. ", " .. self.y .. ")"
end

-- __add metamethod
function Vector.__add(a: Vector, b: Vector)
    return Vector.new(a.x + b.x, a.y + b.y)
end

local v1 = Vector.new(3, 4)
local v2 = Vector.new(1, 2)
local v3 = v1 + v2  -- __add

-------------------------
-- Flow Control
-------------------------

local function classifyScore(score: number): string
    if score > 90 then
        return "excellent"
    elseif score > 50 then
        return "good"
    else
        return "poor"
    end
end

-------------------------
-- Loops
-------------------------

-- Numeric for
for i = 1, 5 do
    count += i
end

-- Generic for over dict
for key, value in pairs(dict) do
    -- iterate
end

-- While loop
local w = 0
while w < 3 do
    w += 1
end

-- Repeat-until loop
local r = 0
repeat
    r += 1
until r == 3

-------------------------
-- Functions, Closures, Varargs
-------------------------

local function makeCounter()
    local n = 0
    return function()
        n += 1
        return n
    end
end

local nextCount = makeCounter()

local function takeVarargs(...: number)
    local sum = 0
    for i, v in ipairs({ ... }) do
        sum += v
    end
    return sum
end

-------------------------
-- Optional types & type narrowing
-------------------------

local function getMaybeNumber(flag: boolean): OptionalInt
    if flag then
        return 123
    end
    return nil
end

local maybe = getMaybeNumber(true)
if maybe ~= nil then
    -- Luau narrows `maybe` to number here
    local doubled = maybe * 2
end

-------------------------
-- Coroutines
-------------------------

local co = coroutine.create(function()
    for i = 1, 3 do
        coroutine.yield(i)
    end
end)

local ok, a = coroutine.resume(co)

-------------------------
-- pcall / error handling
-------------------------

local success, err = pcall(function()
    if math.random() < 0.5 then
        error("Something went wrong!")
    end
end)

-------------------------
-- Example module table
-------------------------

local Module = {}

Module.info = {
    name = "ExampleModule",
    version = "1.0.0",
}

function Module.getPlayerInfo(name: string, team: Team): PlayerInfo
    return {
        name = name,
        score = #name * 10,
    }
end

function Module.demoAll()
    print("Name:", name)
    print("Vector v3 =", tostring(v3))
    print("Classify score 75 →", classifyScore(75))
    print("Counter:", nextCount())
    print("Varargs sum:", takeVarargs(1, 2, 3, 4))
end

return Module
''';
