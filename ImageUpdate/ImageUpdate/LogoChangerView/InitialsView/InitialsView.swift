//
//  InitialsView.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 01/11/2023.
//

import SwiftUI

struct InitialsView: View {
    
    private let maxCharactersCount: Int = 2
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    @ObservedObject private var viewModel: ViewModel
    @Binding var initialsModel: InitialsModel
    
    private let columns: [GridItem] = Array(repeating:
                                                GridItem(.flexible(),
                                                         spacing: 16),
                                            count: 4)
    
    var style: Style

    init(_ initialsModel: Binding<InitialsModel>,
         style: Style) {
        self._initialsModel = initialsModel
        self.viewModel = ViewModel(initialsModel.wrappedValue)
        self.style = style
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Button("Cancel",
                       action: {
                    dismiss()
                })
                
                Spacer()
                
                if !viewModel.initialsModel.title.isEmpty {
                    Button("Save",
                           action: {
                        initialsModel = viewModel.initialsModel
                        dismiss()
                    })
                }
            }
            .padding(16)
            
            TextField("", text: $viewModel.initialsModel.title)
                .frame(width: 100,
                       height: 100)
                .font(.system(size: 48, weight: .bold))
                .background( viewModel.initialsModel.color )
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .onChange(of: viewModel.initialsModel.title, { oldValue, newValue in
                    if newValue.count > maxCharactersCount {
                        viewModel.initialsModel.title = String(newValue.prefix(maxCharactersCount))
                    }
                })
                .clip(with: style)
                .focused($isTextFieldFocused)
            
            if viewModel.isPickerVisible {
                Picker("" ,selection: $viewModel.selectedUpdate, content: {
                    ForEach(ViewModel.Option.allCases, id: \.self) { option in
                        Text(option.title)
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding(32)
                .onChange(of: viewModel.selectedUpdate, { _, newValue in
                    isTextFieldFocused = newValue == .text
                })
            }
            
            if viewModel.isColorCollectionVisible {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.defaultColors, id: \.self) { item in
                            Button(action: {
                                viewModel.initialsModel.color = item
                            }, label: {
                                Text(viewModel.initialsModel.title)
                                    .frame(maxWidth: .infinity)
                                    .frame(maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .background(item)
                                    .font(.system(size: 48, weight: .bold))
                                    .clip(with: style)
                            })
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .onAppear() {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    InitialsView(.constant(InitialsModel(title: "QW")), 
                 style: .circular)
        .fixateMacOSFrame()
}
