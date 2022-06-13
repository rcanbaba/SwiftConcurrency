//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Can Babaoğlu on 13.06.2022.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000) // not always go to background thread, if it wait some func etc possible bg thread
        
        let author2 = "Author2 : \(Thread.current)"
        
        await MainActor.run(body: {
            self.dataArray.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.dataArray.append(author3)
        })
    }
    
}

struct AsyncAwaitBootcamp: View {
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            viewModel.addTitle1()
//            viewModel.addTitle2()
            Task {
                await viewModel.addAuthor1()
                
            }
            
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
