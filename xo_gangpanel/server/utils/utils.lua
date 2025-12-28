local L0_1, L1_1
L0_1 = {}
Core = L0_1
L0_1 = Core
function L1_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = "("
  L4_2 = "("
  L5_2 = {}
  L6_2 = pairs
  L7_2 = A2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = next
    L13_2 = A2_2
    L14_2 = L10_2
    L12_2 = L12_2(L13_2, L14_2)
    if nil == L12_2 then
      L12_2 = L3_2
      L13_2 = "%s)"
      L14_2 = L13_2
      L13_2 = L13_2.format
      L15_2 = L10_2
      L13_2 = L13_2(L14_2, L15_2)
      L12_2 = L12_2 .. L13_2
      L3_2 = L12_2
      L12_2 = L4_2
      L13_2 = "?)"
      L12_2 = L12_2 .. L13_2
      L4_2 = L12_2
      L12_2 = table
      L12_2 = L12_2.insert
      L13_2 = L5_2
      L14_2 = L11_2
      L12_2(L13_2, L14_2)
      break
    end
    L12_2 = L3_2
    L13_2 = "%s, "
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L13_2 = L13_2(L14_2, L15_2)
    L12_2 = L12_2 .. L13_2
    L3_2 = L12_2
    L12_2 = L4_2
    L13_2 = "?, "
    L12_2 = L12_2 .. L13_2
    L4_2 = L12_2
    L12_2 = table
    L12_2 = L12_2.insert
    L13_2 = L5_2
    L14_2 = L11_2
    L12_2(L13_2, L14_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO %s %s VALUES %s"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = A1_2
  L10_2 = L3_2
  L11_2 = L4_2
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  L8_2 = L5_2
  return L6_2(L7_2, L8_2)
end
L0_1.insert = L1_1
L0_1 = Core
function L1_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if not A2_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "SELECT * FROM %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = A1_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L5_2(L6_2, L7_2)
    return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  L4_2 = ""
  L5_2 = {}
  L6_2 = pairs
  L7_2 = A2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = next
    L13_2 = A2_2
    L14_2 = L10_2
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      if "OR" == A3_2 or "or" == A3_2 then
        L12_2 = L4_2
        L13_2 = " %s = ? OR"
        L14_2 = L13_2
        L13_2 = L13_2.format
        L15_2 = L10_2
        L13_2 = L13_2(L14_2, L15_2)
        L12_2 = L12_2 .. L13_2
        L4_2 = L12_2
        L12_2 = table
        L12_2 = L12_2.insert
        L13_2 = L5_2
        L14_2 = L11_2
        L12_2(L13_2, L14_2)
      else
        L12_2 = L4_2
        L13_2 = " %s = ? AND"
        L14_2 = L13_2
        L13_2 = L13_2.format
        L15_2 = L10_2
        L13_2 = L13_2(L14_2, L15_2)
        L12_2 = L12_2 .. L13_2
        L4_2 = L12_2
        L12_2 = table
        L12_2 = L12_2.insert
        L13_2 = L5_2
        L14_2 = L11_2
        L12_2(L13_2, L14_2)
      end
    else
      L12_2 = L4_2
      L13_2 = " %s = ?"
      L14_2 = L13_2
      L13_2 = L13_2.format
      L15_2 = L10_2
      L13_2 = L13_2(L14_2, L15_2)
      L12_2 = L12_2 .. L13_2
      L4_2 = L12_2
      L12_2 = table
      L12_2 = L12_2.insert
      L13_2 = L5_2
      L14_2 = L11_2
      L12_2(L13_2, L14_2)
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT * FROM %s WHERE%s"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = A1_2
  L10_2 = L4_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = L5_2
  return L6_2(L7_2, L8_2)
end
L0_1.select = L1_1
L0_1 = Core
function L1_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if not A2_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = A1_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L5_2(L6_2, L7_2)
    return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  L4_2 = ""
  L5_2 = {}
  L6_2 = pairs
  L7_2 = A2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = next
    L13_2 = A2_2
    L14_2 = L10_2
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      if "OR" == A3_2 or "or" == A3_2 then
        L12_2 = L4_2
        L13_2 = " %s = ? OR"
        L14_2 = L13_2
        L13_2 = L13_2.format
        L15_2 = L10_2
        L13_2 = L13_2(L14_2, L15_2)
        L12_2 = L12_2 .. L13_2
        L4_2 = L12_2
        L12_2 = table
        L12_2 = L12_2.insert
        L13_2 = L5_2
        L14_2 = L11_2
        L12_2(L13_2, L14_2)
      else
        L12_2 = L4_2
        L13_2 = " %s = ? AND"
        L14_2 = L13_2
        L13_2 = L13_2.format
        L15_2 = L10_2
        L13_2 = L13_2(L14_2, L15_2)
        L12_2 = L12_2 .. L13_2
        L4_2 = L12_2
        L12_2 = table
        L12_2 = L12_2.insert
        L13_2 = L5_2
        L14_2 = L11_2
        L12_2(L13_2, L14_2)
      end
    else
      L12_2 = L4_2
      L13_2 = " %s = ?"
      L14_2 = L13_2
      L13_2 = L13_2.format
      L15_2 = L10_2
      L13_2 = L13_2(L14_2, L15_2)
      L12_2 = L12_2 .. L13_2
      L4_2 = L12_2
      L12_2 = table
      L12_2 = L12_2.insert
      L13_2 = L5_2
      L14_2 = L11_2
      L12_2(L13_2, L14_2)
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "DELETE FROM %s WHERE%s"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = A1_2
  L10_2 = L4_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = L5_2
  return L6_2(L7_2, L8_2)
end
L0_1.delete = L1_1
L0_1 = Core
function L1_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L5_2 = ""
  L6_2 = ""
  L7_2 = {}
  L8_2 = pairs
  L9_2 = A2_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = next
    L15_2 = A2_2
    L16_2 = L12_2
    L14_2 = L14_2(L15_2, L16_2)
    if L14_2 then
      L14_2 = L6_2
      L15_2 = " %s = ?,"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L12_2
      L15_2 = L15_2(L16_2, L17_2)
      L14_2 = L14_2 .. L15_2
      L6_2 = L14_2
      L14_2 = table
      L14_2 = L14_2.insert
      L15_2 = L7_2
      L16_2 = L13_2
      L14_2(L15_2, L16_2)
    else
      L14_2 = L6_2
      L15_2 = " %s = ?"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L12_2
      L15_2 = L15_2(L16_2, L17_2)
      L14_2 = L14_2 .. L15_2
      L6_2 = L14_2
      L14_2 = table
      L14_2 = L14_2.insert
      L15_2 = L7_2
      L16_2 = L13_2
      L14_2(L15_2, L16_2)
    end
  end
  L8_2 = pairs
  L9_2 = A3_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = next
    L15_2 = A3_2
    L16_2 = L12_2
    L14_2 = L14_2(L15_2, L16_2)
    if L14_2 then
      if "OR" == A4_2 or "or" == A4_2 then
        L14_2 = L5_2
        L15_2 = " %s = ? OR"
        L16_2 = L15_2
        L15_2 = L15_2.format
        L17_2 = L12_2
        L15_2 = L15_2(L16_2, L17_2)
        L14_2 = L14_2 .. L15_2
        L5_2 = L14_2
        L14_2 = table
        L14_2 = L14_2.insert
        L15_2 = L7_2
        L16_2 = L13_2
        L14_2(L15_2, L16_2)
      else
        L14_2 = L5_2
        L15_2 = " %s = ? AND"
        L16_2 = L15_2
        L15_2 = L15_2.format
        L17_2 = L12_2
        L15_2 = L15_2(L16_2, L17_2)
        L14_2 = L14_2 .. L15_2
        L5_2 = L14_2
        L14_2 = table
        L14_2 = L14_2.insert
        L15_2 = L7_2
        L16_2 = L13_2
        L14_2(L15_2, L16_2)
      end
    else
      L14_2 = L5_2
      L15_2 = " %s = ?"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L12_2
      L15_2 = L15_2(L16_2, L17_2)
      L14_2 = L14_2 .. L15_2
      L5_2 = L14_2
      L14_2 = table
      L14_2 = L14_2.insert
      L15_2 = L7_2
      L16_2 = L13_2
      L14_2(L15_2, L16_2)
    end
  end
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = "UPDATE %s SET%s WHERE%s"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = A1_2
  L12_2 = L6_2
  L13_2 = L5_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  L10_2 = L7_2
  return L8_2(L9_2, L10_2)
end
L0_1.update = L1_1
