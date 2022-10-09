import React, {Component} from 'react';
import PlotlyEditor from 'react-chart-editor';
import plotly from 'plotly.js/dist/plotly';
import 'react-chart-editor/lib/react-chart-editor.css';

class App extends Component {
  constructor() {
    super();

    this.state = {
      data: [],
      layout: {},
      config: {}
    };
  }

  UNSAFE_componentWillMount() {
    const searchParams = new URLSearchParams(window.location.search);
    const plotURL = searchParams.get('plotURL');

    if (!plotURL) {
      return; // TODO: maybe alert with an informative message?
    }    

    fetch(plotURL)
      .then(response => response.json())
      .then(fig => { 
        console.log("Figure", fig);
        this.setState({data: fig.data, layout: fig.layout, config: fig.config});
      });
  }

  render() {
    return (
      <div className="app">
        <PlotlyEditor
          data={this.state.data}
          layout={this.state.layout}
          config={this.state.config}
          plotly={plotly}
          onUpdate={(data, layout, frames) => this.setState({data, layout, frames})}
          useResizeHandler
          debug
          advancedTraceTypeSelector
        />
      </div>
    );
  }
}

export default App;
