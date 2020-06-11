#tag Class
Protected Class LinkLabel
Inherits Label
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  mMouseIsDown = False
		  
		  If mIsAURI = False Then
		    Return RaiseEvent MouseDown(x,y)
		  Else
		    mMouseIsDown = True
		    
		    Me.Underline = true
		    
		    Return True
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  If mIsAURI Then
		    Me.TextColor = HoverColor
		    
		    Me.Invalidate
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  If mIsAURI Then
		    If mMouseIsDown Then
		      Me.TextColor = PressedColor
		    Else
		      Me.TextColor = LinkColor
		    End If
		    
		    Me.Invalidate
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  If mIsAURI = False Then
		    RaiseEvent MouseUp(x,y)
		  Else
		    ShowURL mURL
		    
		    mMouseIsDown = False
		    
		    If mIsAURI then
		      Me.TextColor = LinkColor
		    Else
		      Me.TextColor = REALbasic.TextColor
		    End If
		    
		  End If
		  
		End Sub
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event MouseDown(X As Integer, Y As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseEnter()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseExit()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseUp(X As Integer, Y As Integer)
	#tag EndHook


	#tag Property, Flags = &h0
		HoverColor As color = &c883782
	#tag EndProperty

	#tag Property, Flags = &h0
		LinkColor As color = &c0A5FfE
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mIsAURI As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMouseIsDown As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mOriginal As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mURL As string
	#tag EndProperty

	#tag Property, Flags = &h0
		PressedColor As color = &c55C7FE
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mOriginal
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // validate this as far as we need to to know if its a valid URI we recognize
			  // based on the reg ex in https://tools.ietf.org/html/rfc3986#page-50
			  // you know like the ACTUAL RFC :)
			  '
			  ' ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
			  '  12            3  4          5       6  7        8 9
			  '
			  'The numbers In the second line above are only To assist readability;
			  'they indicate the reference points For Each subexpression (i.e., Each
			  'paired parenthesis).  We refer To the value matched For subexpression
			  '<n> As $<n>.  For example, matching the above expression To
			  '
			  'http://www.ics.uci.edu/pub/ietf/uri/#Related
			  '
			  'results In the following subexpression matches:
			  '
			  '$1 = http:
			  '$2 = http
			  '$3 = //www.ics.uci.edu
			  '$4 = www.ics.uci.edu
			  '$5 = /pub/ietf/uri/
			  '$6 = <undefined>
			  '$7 = <undefined>
			  '$8 = #Related
			  
			  Dim tmp As String = value
			  mOriginal = value
			  
			  Me.Text = value
			  
			  // lets see IF it has a SCHEME
			  // if it does then we wont touch it at all
			  // if not lets assume https 
			  
			  Dim rx As New RegEx
			  rx.SearchPattern = "(?mi-Us)^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?"
			  
			  Dim rxOptions As RegExOptions = rx.Options
			  rxOptions.LineEndType = 4
			  
			  Dim match As RegExMatch = rx.Search( tmp )
			  
			  If match <> Nil And match.SubExpressionString(1) <> "" And  match.SubExpressionString(2) <> "" Then
			    
			    mIsAURI = True
			    // and this means we DO have a valid scheme !
			    mURL = value
			    
			  Else
			    
			    // they gave us www.google.com or something ?
			    If value.Left(8) <> "https://" And value.Left(7) <> "http://" Then
			      
			      match = rx.Search( "https://" + tmp )
			      
			      If match <> Nil And match.SubExpressionString(1) <> "" And  match.SubExpressionString(2) <> "" Then
			        
			        mIsAURI = True
			        
			        // and this means we DO have a valid scheme !
			        mURL = "https://" + value
			         
			      End If
			      
			    End If
			    
			  End If
			  
			  If mIsAURI Then
			    Me.Underline = True
			    Me.TextColor = LinkColor
			  Else
			    Me.TextColor = REALbasic.TextColor
			  End If
			  
			End Set
		#tag EndSetter
		URL As string
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="20"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multiline"
			Visible=true
			Group="Appearance"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Selectable"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Text"
			Visible=true
			Group="Appearance"
			InitialValue="Untitled"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextAlign"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Left"
				"1 - Center"
				"2 - Right"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=true
			Group="Appearance"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=true
			Group="Font"
			InitialValue="System"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextUnit"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="FontUnits"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Pixel"
				"2 - Point"
				"3 - Inch"
				"4 - Millimeter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataSource"
			Visible=true
			Group="Database Binding"
			Type="String"
			EditorType="DataSource"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataField"
			Visible=true
			Group="Database Binding"
			Type="String"
			EditorType="DataField"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URL"
			Visible=true
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinkColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c0A5FFE"
			Type="color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PressedColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c55C7FE"
			Type="color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HoverColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c883A82"
			Type="color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Type="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
