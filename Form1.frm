VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Terbilang Desimal Indonesia"
   ClientHeight    =   3090
   ClientLeft      =   -15
   ClientTop       =   375
   ClientWidth     =   4950
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3090
   ScaleWidth      =   4950
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox Text2 
      Height          =   1815
      Left            =   240
      MultiLine       =   -1  'True
      TabIndex        =   1
      Text            =   "Form1.frx":0000
      Top             =   1080
      Width           =   4455
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   240
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   720
      Width           =   1575
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Function TerbilangDesimal(InputCurrency As String, Optional MataUang As String = "rupiah") As String
 Dim strInput As String
 Dim strBilangan As String
 Dim strPecahan As String
   On Error GoTo Pesan
   Dim strValid As String, huruf As String * 1
   Dim i As Integer
   'Periksa setiap karakter yg diketikkan ke kotak
   'UserID
   strValid = "1234567890,"
   For i% = 1 To Len(InputCurrency)
     huruf = Chr(Asc(Mid(InputCurrency, i%, 1)))
     If InStr(strValid, huruf) = 0 Then
       Set AngkaTerbilang = Nothing
       MsgBox "Harus karakter angka!", _
              vbCritical, "Karakter Tidak Valid"
       Exit Function
     End If
   Next i%
 
 If InputCurrency = "" Then Exit Function
 If Len(Trim(InputCurrency)) > 15 Then GoTo Pesan
 
 strInput = CStr(InputCurrency) 'Konversi ke string
 'Periksa apakah ada tanda "," jika ya berarti pecahan
 If InStr(1, strInput, ",", vbBinaryCompare) Then
      
  strBilangan = Left(strInput, InStr(1, strInput, _
                ",", vbBinaryCompare) - 1)
  'strBilangan = Right(strInput, InStr(1, strInput, _
  '              ".", vbBinaryCompare) - 2)
  strPecahan = Trim(Right(strInput, Len(strInput) - Len(strBilangan) - 1))
  
  If MataUang <> "" Then
      
  If CLng(Trim(strPecahan)) > 99 Then
     strInput = Format(Round(CDbl(strInput), 2), "#0.00")
     strPecahan = Format((Right(strInput, Len(strInput) - Len(strBilangan) - 1)), "00")
    End If
    
    If Len(Trim(strPecahan)) = 1 Then
       strInput = Format(Round(CDbl(strInput), 2), _
                  "#0.00")
       strPecahan = Format((Right(strInput, _
          Len(strInput) - Len(strBilangan) - 1)), "00")
    End If
    
    If CLng(Trim(strPecahan)) = 0 Then
    TerbilangDesimal = (KonversiBilangan(strBilangan) & MataUang & " " & KonversiBilangan(strPecahan))
 Else
  TerbilangDesimal = (KonversiBilangan(strBilangan) & MataUang & " " & KonversiBilangan(strPecahan) & "sen")
    End If
  Else
    TerbilangDesimal = (KonversiBilangan(strBilangan) & "koma " & KonversiPecahan(strPecahan))
  End If
  
 Else
    TerbilangDesimal = (KonversiBilangan(strInput))
  End If
 Exit Function
Pesan:
  TerbilangDesimal = "(maksimal 15 digit)"
End Function

'Fungsi ini untuk mengkonversi nilai pecahan (setelah 'angka 0)
Private Function KonversiPecahan(strAngka As String) As String
Dim i%, strJmlHuruf$, Urai$, Kar$
 If strAngka = "" Then Exit Function
    strJmlHuruf = Trim(strAngka)
    Urai = ""
    Kar = ""
    For i = 1 To Len(strJmlHuruf)
      'Tampung setiap satu karakter ke Kar
      Kar = Mid(strAngka, i, 1)
      Urai = Urai & Kata(CInt(Kar))
    Next i
    KonversiPecahan = Urai
End Function

'Fungsi ini untuk menterjemahkan setiap satu angka ke 'kata
Private Function Kata(angka As Byte) As String
   Select Case angka
          Case 1: Kata = "satu "
          Case 2: Kata = "dua "
          Case 3: Kata = "tiga "
          Case 4: Kata = "empat "
          Case 5: Kata = "lima "
          Case 6: Kata = "enam "
          Case 7: Kata = "tujuh "
          Case 8: Kata = "delapan "
          Case 9: Kata = "sembilan "
          Case 0: Kata = "nol "
   End Select
End Function

'Ini untuk mengkonversi nilai bilangan sebelum pecahan
Private Function KonversiBilangan(strAngka As String) As String
Dim strJmlHuruf$, intPecahan As Integer, strPecahan$, Urai$, Bil1$, strTot$, Bil2$
 Dim X, Y, z As Integer

 If strAngka = "" Then Exit Function
    strJmlHuruf = Trim(strAngka)
    X = 0
    Y = 0
    Urai = ""
    While (X < Len(strJmlHuruf))
      X = X + 1
      strTot = Mid(strJmlHuruf, X, 1)
      Y = Y + Val(strTot)
      z = Len(strJmlHuruf) - X + 1
      Select Case Val(strTot)
      'Case 0
       '   Bil1 = "NOL "
      Case 1
          If (z = 1 Or z = 7 Or z = 10 Or z = 13) Then
              Bil1 = "satu "
          ElseIf (z = 4) Then
              If (X = 1) Then
                  Bil1 = "se"
              Else
                  Bil1 = "satu "
              End If
          ElseIf (z = 2 Or z = 5 Or z = 8 Or z = 11 Or z = 14) Then
              X = X + 1
              strTot = Mid(strJmlHuruf, X, 1)
              z = Len(strJmlHuruf) - X + 1
              Bil2 = ""
              Select Case Val(strTot)
              Case 0
                  Bil1 = "sepuluh "
              Case 1
                  Bil1 = "sebelas "
              Case 2
                  Bil1 = "dua belas "
              Case 3
                  Bil1 = "tiga belas "
              Case 4
                  Bil1 = "empat belas "
              Case 5
                  Bil1 = "lima belas "
              Case 6
                  Bil1 = "enam belas "
              Case 7
                  Bil1 = "tujuh belas "
              Case 8
                  Bil1 = "delapan belas "
              Case 9
                  Bil1 = "sembilan belas "
              End Select
          Else
              Bil1 = "se"
          End If
      
      Case 2
          Bil1 = "dua "
      Case 3
          Bil1 = "tiga "
      Case 4
          Bil1 = "empat "
      Case 5
          Bil1 = "lima "
      Case 6
          Bil1 = "enam "
      Case 7
          Bil1 = "tujuh "
      Case 8
          Bil1 = "delapan "
      Case 9
          Bil1 = "sembilan "
      Case Else
          Bil1 = ""
      End Select
       
      If (Val(strTot) > 0) Then
         If (z = 2 Or z = 5 Or z = 8 Or z = 11 Or z = 14) Then
            Bil2 = "puluh "
         ElseIf (z = 3 Or z = 6 Or z = 9 Or z = 12 Or z = 15) Then
            Bil2 = "ratus "
         Else
            Bil2 = ""
         End If
      Else
         Bil2 = ""
      End If
      If (Y > 0) Then
          Select Case z
          Case 4
              Bil2 = Bil2 + "ribu "
              Y = 0
          Case 7
              Bil2 = Bil2 + "juta "
              Y = 0
          Case 10
              Bil2 = Bil2 + "milyar "
              Y = 0
          Case 13
              Bil2 = Bil2 + "trilyun "
              Y = 0
          End Select
      End If
      Urai = Urai + Bil1 + Bil2
  Wend
  KonversiBilangan = Urai
End Function

Private Sub Form_Load()
    With Me
        .Text1.Text = Empty
        .Text2.Text = Empty
    End With
End Sub

Private Sub Text1_Change()  'Isi besar uang diulangi 'dengan terbilang huruf...
   Text2.Text = TerbilangDesimal(Text1.Text)
End Sub

