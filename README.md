# Unhalted Unit Frames

## Libraries
- [oUF](https://www.curseforge.com/wow/addons/ouf)
- [Ace3](https://www.curseforge.com/wow/addons/ace3)

## Current State
- The current state of this AddOn is very specific to my UI layout. All elements are hard-coded utilizing the oUF framework.
- If you decide to install this AddOn, Player / Target / Boss Frames will be present.
- As the need arises, I will be updating and adding more frames.

## Goal
- The goal is to create a Unit Frame AddOn to replace Shadowed Unit Frames. Although this AddOn is fantastic and I have been using it for some time, I found myself constantly making changes for my own aesthetic so therefore, built my own instead.
- Additionally, these Unit Frames are focused primarily on performance whilst maintaining aesthetics.

## Features
- Range Check.
    - This has been adapted to check on events rather than `OnUpdate` or `C_Timer` calls.
    - Range Checks are also only applied to `Target` and `Boss Frames`.
- Incoming Heals / Absorbs / Heal Absorbs
    - Although this is not necessarily very performance-focused, I find them useful.

## Utilisation
- For the most part, all code has been commented to help users understand where changes can be made.
- The primary function, `CreateUnitFrame` has a substantial amount of parameters that will be changed in the future.
- Parameters are as follows:

<table align="center">
  <tr>
    <th style="text-align:center;">Name</th>
    <th style="text-align:center;">Argument</th>
    <th style="text-align:center;">Variable Type</th>
    <th style="text-align:center;">Description</th>
  </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Frame</td>
        <td style="text-align:center;">1</td>
        <td style="text-align:center; font-style:italic">Frame</td>
        <td style="text-align:left;">Creates the frame specified. Always leave this as `self`.</td>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Width</td>
        <td style="text-align:center;">2</td>
        <td style="text-align:center; font-style:italic">Number</td>
        <td style="text-align:left;">Specifies the width of the frame being created.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Height</td>
        <td style="text-align:center;">3</td>
        <td style="text-align:center; font-style:italic">Number</td>
        <td style="text-align:left;">Specifies the height of the frame being created.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Inverse Fill</td>
        <td style="text-align:center;">4</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether the health should be inverted in direction.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Power Bar</td>
        <td style="text-align:center;">5</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the power bar on the created frame.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Power Text</td>
        <td style="text-align:center;">6</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the power text on the created frame.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Buffs</td>
        <td style="text-align:center;">7</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the buffs on the created frame.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Name</td>
        <td style="text-align:center;">8</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the name of the unit on the created frame.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Target of Target</td>
        <td style="text-align:center;">9</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the name target of target on the created frame.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Health Tag</td>
        <td style="text-align:center;">10</td>
        <td style="text-align:center; font-style:italic">Tag / String</td>
        <td style="text-align:left;">Determines which tag is seen on the unit.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Incoming Heals</td>
        <td style="text-align:center;">11</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the incoming heals on the created frame.</td>
    </tr>
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Absorbs</td>
        <td style="text-align:center;">12</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the absorbs on the created frame.</td>
    </tr> 
    </tr>
        <tr>
        <td style="text-align:center; font-weight:bold;">Heal Absorbs</td>
        <td style="text-align:center;">13</td>
        <td style="text-align:center; font-style:italic">Boolean</td>
        <td style="text-align:left;">States whether to display the heal absorbs on the created frame.</td>
    </tr>      
</table>

## Useful Tags

<table align="center">
  <tr>
    <th style="text-align:center;">Tag Name</th>
    <th style="text-align:center;">Tag String</th>
    <th style="text-align:center;">Description</th>
  </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Current Health with Percent</td>
        <td style="text-align:center;"><code>Health:CurrentWithPercent:Short</code></td>
        <td style="text-align:left;">Displays current health with health percent.</td>
    </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Current Health with Percent with Absorbs</td>
        <td style="text-align:center;"><code>Health:EffectiveCurrentWithPercent:Short</code></td>
        <td style="text-align:left;">Displays current health with health percent with absorbs included (only for percentage value).</td>
    </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Current Power</td>
        <td style="text-align:center;"><code>Power:Current:Short</code></td>
        <td style="text-align:left;">Displays current power.</td>
    </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Target of Target</td>
        <td style="text-align:center;"><code>Name:TargetofTarget</code></td>
        <td style="text-align:left;">Appends the target of target name alongside the unit name.</td>
    </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Target of Target - Shorten</td>
        <td style="text-align:center;"><code>Name:TargetofTarget:Shorten</code></td>
        <td style="text-align:left;">Shorten unit name whilst still appending the target of target name.</td>
    </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Target of Target - Colored</td>
        <td style="text-align:center;"><code>Name:TargetofTarget:Colored</code></td>
        <td style="text-align:left;">Appends the target of target name alongside the unit name. Wraps unit and target of target name in class or reaction colour.</td>
    </tr>
    <tr>
        <td style="text-align:center; font-weight:bold;">Target of Target - Shorten & Colored</td>
        <td style="text-align:center;"><code>Name:TargetofTarget:Colored:Shorten</code></td>
        <td style="text-align:left;">Shorten unit name whilst still appending the target of target name. Wraps unit and target of target name in class or reaction colour.</td>
    </tr>    
</table>

**More options can be found and created in `Tags.lua`**

